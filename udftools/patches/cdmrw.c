/*
 * Copyright (c) 2002 Jens Axboe <axboe@suse.de>
 *
 * cdmrw -- utility to manage mt rainier cd drives + media
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License version 2 as
 *   published by the Free Software Foundation.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <byteswap.h>
#include <sys/ioctl.h>

#include <linux/cdrom.h>

#define INIT_CGC(cgc)	memset((cgc), 0, sizeof(struct cdrom_generic_command))

#define FORMAT_TYPE_RESTART	1
#define FORMAT_TYPE_FULL	2

#define LBA_DMA			0
#define LBA_GAA			1

/*
 * early mrw drives may use mode page 0x2c still, 0x03 is the official one
 */
#define MRW_MODE_PC_PRE1	0x2c
#define MRW_MODE_PC		0x03

#define UHZ			100

static int format_type, format_force, poll_wait, poll_err, suspend_format;
static int lba_space = -1, mrw_mode_page;

static char mrw_device[256];

static char *lba_spaces[] = { "DMA", "GAA" };

void dump_cgc(struct cdrom_generic_command *cgc)
{
	struct request_sense *sense = cgc->sense;
	int i;

	printf("cdb: ");
	for (i = 0; i < 12; i++)
		printf("%02x ", cgc->cmd[i]);
	printf("\n");

	printf("buffer (%d): ", cgc->buflen);
	for (i = 0; i < cgc->buflen; i++)
		printf("%02x ", cgc->buffer[i]);
	printf("\n");

	if (!sense)
		return;

	printf("sense: %02x.%02x.%02x\n", sense->sense_key, sense->asc, sense->ascq);
}

/*
 * issue packet command (blocks until it has completed)
 */
int wait_cmd(int fd, struct cdrom_generic_command *cgc, void *buffer,
	     int len, int ddir, int timeout, int quiet)
{
	struct request_sense sense;
	int ret;

	memset(&sense, 0, sizeof(sense));

	cgc->timeout = timeout;
	cgc->buffer = buffer;
	cgc->buflen = len;
	cgc->data_direction = ddir;
	cgc->sense = &sense;
	cgc->quiet = 0;

	ret = ioctl(fd, CDROM_SEND_PACKET, cgc);
	if (ret == -1 && !quiet) {
		perror("ioctl");
		dump_cgc(cgc);
	}

	return ret;
}

int start_bg_format(int fd, int new)
{
	struct cdrom_generic_command cgc;
	unsigned char buffer[12];

	INIT_CGC(&cgc);
	memset(buffer, 0, sizeof(buffer));

	cgc.cmd[0] = GPCMD_FORMAT_UNIT;
	cgc.cmd[1] = (1 << 4) | 1;

	buffer[1] = 1 << 1;
	buffer[3] = 8;

	buffer[4] = 0xff;
	buffer[5] = 0xff;
	buffer[6] = 0xff;
	buffer[7] = 0xff;
	buffer[8] = 0x24 << 2;
	buffer[11] = !new;

	return wait_cmd(fd, &cgc, buffer, sizeof(buffer), CGC_DATA_WRITE, 120 * UHZ, 0);
}

/*
 * instantiate a format, if appropriate
 */
int mrw_format(int fd, int media_status)
{
	if (media_status == CDM_MRW_BGFORMAT_ACTIVE) {
		printf("%s: back ground format already active\n", mrw_device);
		return 1;
	} else if (media_status == CDM_MRW_BGFORMAT_COMPLETE && !format_force) {
		printf("%s: disc is already mrw formatted\n", mrw_device);
		return 1;
	}

	if (format_type == FORMAT_TYPE_RESTART && media_status != CDM_MRW_BGFORMAT_INACTIVE) {
		printf("%s: can't restart format, need full\n", mrw_device);
		return 1;
	}

	return start_bg_format(fd, format_type == FORMAT_TYPE_FULL);
}

int mrw_format_suspend(int fd, int media_status)
{
	struct cdrom_generic_command cgc;

	if (media_status != CDM_MRW_BGFORMAT_ACTIVE) {
		printf("%s: can't suspend, format not running\n", mrw_device);
		return 1;
	}

	printf("%s: suspending back ground format: ", mrw_device);

	INIT_CGC(&cgc);

	cgc.cmd[0] = GPCMD_CLOSE_TRACK;
	cgc.cmd[1] = 0; /* IMMED */
	cgc.cmd[2] = 1 << 1;

	if (wait_cmd(fd, &cgc, NULL, 0, CGC_DATA_NONE, 300 * UHZ, 0)) {
		printf("failed\n");
		return 1;
	}

	printf("done\n");
	return 0;
}

int get_media_event(int fd)
{
	struct cdrom_generic_command cgc;
	unsigned char buffer[8];
	int ret;

	INIT_CGC(&cgc);
	memset(buffer, 0, sizeof(buffer));

	cgc.cmd[0] = GPCMD_GET_EVENT_STATUS_NOTIFICATION;
	cgc.cmd[1] = 1;
	cgc.cmd[4] = 16;
	cgc.cmd[8] = sizeof(buffer);

	ret = wait_cmd(fd, &cgc, buffer, sizeof(buffer), CGC_DATA_READ, 10*UHZ, 0);
	if (ret < 0) {
		perror("GET_EVENT");
		return ret;
	}

	return buffer[4] & 0xf;
}

int get_progress(int fd)
{
	struct cdrom_generic_command cgc;
	struct request_sense sense;
	int progress;

	INIT_CGC(&cgc);
	memset(&sense, 0, sizeof(sense));

	cgc.cmd[0] = GPCMD_TEST_UNIT_READY;
	cgc.sense = &sense;

	(void) wait_cmd(fd, &cgc, NULL, 0, CGC_DATA_NONE, 10 * UHZ, 0);

	printf("progress: ");
	if (sense.sks[0] & 0x80) {
		progress = (sense.sks[1] << 8) + sense.sks[2];
		fprintf(stderr, "%d%%\r", progress);
	} else
		printf("no progress indicator\n");

	return 0;
}

int get_format_progress(int fd)
{
	struct cdrom_generic_command cgc;
	struct request_sense sense;

#if 0
	if (poll_err)
		return 0;
#endif

	INIT_CGC(&cgc);
	memset(&sense, 0, sizeof(sense));

	cgc.cmd[0] = GPCMD_TEST_UNIT_READY;
	cgc.sense = &sense;

	if (wait_cmd(fd, &cgc, NULL, 0, CGC_DATA_NONE, 10 * UHZ, 0)) {
		printf("%s: TUR failed\n", mrw_device);
		return 0;
	}

	/*
	 * all mrw drives should support progress indicator, but you never
	 * know...
	 */
	if (!(sense.sks[0] & 0x80)) {
		printf("drive fails to support progress indicator\n");
		poll_err = 1;
		//return 0;
	}

	return (sense.sks[1] << 8) + sense.sks[2];
}

/*
 * return mrw media status bits from disc info or -1 on failure
 */
int get_mrw_media_status(int fd)
{
	struct cdrom_generic_command cgc;
	disc_information di;

	INIT_CGC(&cgc);

	cgc.cmd[0] = GPCMD_READ_DISC_INFO;
	cgc.cmd[8] = sizeof(di);

	if (wait_cmd(fd, &cgc, &di, sizeof(di), CGC_DATA_READ, UHZ, 0)) {
		printf("read disc info failed\n");
		return -1;
	}

	return di.mrw_status;
}

int poll_events(int fd)
{
	int event, quit, first, progress, media_status;

	quit = 0;
	first = 1;
	do {
		event = get_media_event(fd);
		if (event < 0)
			break;

		switch (event) {
			case 0:
				if (first)
					printf("no media change\n");
				break;
			case 1:
				printf("eject request\n");
				if ((media_status = get_mrw_media_status(fd)) == -1)
					break;
				if (media_status == CDM_MRW_BGFORMAT_ACTIVE)
					mrw_format_suspend(fd, media_status);
				quit = 1;
				break;
			case 2:
				printf("new media\n");
				break;
			case 3:
				printf("media removal\n");
				quit = 1;
				break;
			case 4:
				printf("media change\n");
				break;
			case 5:
				printf("bgformat complete!\n");
				quit = 1;
				break;
			case 6:
				printf("bgformat automatically restarted\n");
				break;
			default:
				printf("unknown media event (%d)\n", event);
				break;
		}

		if (!quit) {
			first = 0;
			progress = get_progress(fd);
			if (event)
				continue;

			sleep(2);
		}

	} while (!quit);

	return event;
}

/*
 * issue GET_CONFIGURATION and check for the mt rainier profile
 */
int check_for_mrw(int fd)
{
	struct mrw_feature_desc *mfd;
	struct cdrom_generic_command cgc;
	char buffer[16];

	INIT_CGC(&cgc);

	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
	cgc.cmd[3] = CDF_MRW;
	cgc.cmd[8] = sizeof(buffer);

	if (wait_cmd(fd, &cgc, buffer, sizeof(buffer), CGC_DATA_READ, UHZ, 1))
		return 1;

	mfd = (struct mrw_feature_desc *)&buffer[sizeof(struct feature_header)];

	return !mfd->write;
}

int __get_lba_space(int fd, int pc, char *buffer, int size)
{
	struct cdrom_generic_command cgc;

	INIT_CGC(&cgc);

	cgc.cmd[0] = GPCMD_MODE_SENSE_10;
	cgc.cmd[2] = pc | (0 << 6);
	cgc.cmd[8] = size;

	if (wait_cmd(fd, &cgc, buffer, size, CGC_DATA_READ, UHZ, 1))
		return 1;

	return 0;
}

/*
 * return LBA_DMA or LBA_GAA, -1 on failure
 */
int get_lba_space(int fd)
{
	struct mode_page_header *mph;
	char buffer[32];
	int offset;

	if (__get_lba_space(fd, mrw_mode_page, buffer, sizeof(buffer)))
		return -1;

	mph = (struct mode_page_header *) buffer;
	offset = sizeof(*mph) + bswap_16(mph->desc_length);

	/*
	 * LBA space bit is bit 0 in byte 3 of the mrw mode page
	 */
	return buffer[offset + 3] & 1;
}

int probe_mrw_mode_page(int fd)
{
	char buffer[32];

	mrw_mode_page = -1;

	if (!__get_lba_space(fd, MRW_MODE_PC, buffer, sizeof(buffer)))
		mrw_mode_page = MRW_MODE_PC;
	else if (!__get_lba_space(fd, MRW_MODE_PC_PRE1, buffer, sizeof(buffer)))
		mrw_mode_page = MRW_MODE_PC_PRE1;

	if (mrw_mode_page == MRW_MODE_PC_PRE1)
		printf("%s: still using deprecated mrw mode page\n",mrw_device);

	return mrw_mode_page;
}

int switch_lba_space(int fd, int lba_space)
{
	struct cdrom_generic_command cgc;
	struct mode_page_header *mph;
	int cur_space, offset, size;
	char buffer[32];

	if (__get_lba_space(fd, mrw_mode_page, buffer, sizeof(buffer)))
		return 1;

	mph = (struct mode_page_header *) buffer;
	offset = sizeof(*mph) + bswap_16(mph->desc_length);
	cur_space = buffer[offset + 3] & 1;

	if (cur_space == lba_space)
		return 0;

	/*
	 * mode data length doesn't include its own space
	 */
	size = bswap_16(mph->mode_data_length) + 2;

	/*
	 * init command and set the required lba space
	 */
	INIT_CGC(&cgc);

	cgc.cmd[0] = GPCMD_MODE_SELECT_10;
	cgc.cmd[8] = size;

	buffer[offset + 3] = lba_space;

	if (wait_cmd(fd, &cgc, buffer, size, CGC_DATA_WRITE, UHZ, 0))
		return 1;

	return 0;
}

void print_mrw_status(int media_status)
{
	switch (media_status) {
		case CDM_MRW_NOTMRW:
			printf("not a mrw formatted disc\n");
			break;
		case CDM_MRW_BGFORMAT_INACTIVE:
			printf("mrw format inactive and not complete\n");
			break;
		case CDM_MRW_BGFORMAT_ACTIVE:
			printf("mrw format running\n");
			break;
		case CDM_MRW_BGFORMAT_COMPLETE:
			printf("disc is mrw formatted\n");
			break;
	}
}

void print_options(const char *prg)
{
	printf("%s: options:\n", prg);
	printf("\t-d:\t<device>\n");
	printf("\t-f:\t<{restart, full} format type\n");
	printf("\t-F:\tforce format\n");
	printf("\t-s:\tsuspend format\n");
	printf("\t-p:\tpoll for format completion\n");
}

void get_options(int argc, char *argv[])
{
	char c;

	strcpy(mrw_device, "/dev/cdrom");

	while ((c = getopt(argc, argv, "d:f:Fpsl:")) != EOF) {
		switch (c) {
			case 'd':
				strcpy(mrw_device, optarg);
				break;
			case 'f':
				if (!strcmp(optarg, "full"))
					format_type = FORMAT_TYPE_FULL;
				else if (!strcmp(optarg, "restart"))
					format_type = FORMAT_TYPE_RESTART;
				else
					printf("%s: invalid format type %s\n", argv[0], optarg);
				break;
			case 'F':
				format_force = 1;
				break;
			case 'p':
				poll_wait = 1;
				break;
			case 's':
				suspend_format = 1;
				break;
			case 'l':
				if (!strcmp(optarg, "gaa"))
					lba_space = LBA_GAA;
				else if (!strcmp(optarg, "dma"))
					lba_space = LBA_DMA;
				else
					printf("%s: invalid address space %s\n", argv[0], optarg);
				break;
			default:
				if (optarg)
					printf("%s: unknown option '%s'\n", argv[0], optarg);
				print_options(argv[0]);
				exit(1);
		}
	}
}

int main(int argc, char *argv[])
{
	int fd, media_status, progress;

	if (argc == 1) {
		print_options(argv[0]);
		return 1;
	}

	get_options(argc, argv);

	fd = open(mrw_device, O_RDONLY | O_NONBLOCK);
	if (fd == -1) {
		perror("open");
		return 1;
	}

	if (check_for_mrw(fd)) {
		printf("%s: %s is not a mrw drive or mrw reader\n", argv[0], mrw_device);
		return 1;
	}

	if ((media_status = get_mrw_media_status(fd)) == -1) {
		printf("%s: failed to retrieve media status\n", argv[0]);
		return 1;
	}

	print_mrw_status(media_status);

	if (probe_mrw_mode_page(fd) == -1) {
		printf("%s: failed to probe mrw mode page\n", mrw_device);
		return 1;
	}

	if (lba_space != -1) {
		if (switch_lba_space(fd, lba_space)) {
			printf("%s: failed switching lba space\n", mrw_device);
			return 1;
		}
	}

	printf("LBA space: %s\n", lba_spaces[get_lba_space(fd)]);

	if (media_status == CDM_MRW_BGFORMAT_ACTIVE) {
		progress = get_format_progress(fd);
		printf("%s: back ground format %d%% complete\n", mrw_device, progress);
	}

	if (format_type) {
		if (mrw_format(fd, media_status))
			return 1;
	} else if (suspend_format)
		mrw_format_suspend(fd, media_status);

	if (poll_wait)
		poll_events(fd);

	return 0;
}
