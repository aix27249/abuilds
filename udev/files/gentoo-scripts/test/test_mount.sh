#!/bin/sh

oneTimeSetUp()
{
	sed -e "s#/proc/filesystems#${SHUNIT_TMPDIR}/proc-filesystems#" \
	    -e "s#^.*/lib/udev/shell-compat-KV.sh##" \
	    < ../init.d/udev-mount \
	    > "${SHUNIT_TMPDIR}"/udev-mount.initd
	cp "${SHUNIT_TMPDIR}"/udev-mount.initd /tmp
	. "${SHUNIT_TMPDIR}"/udev-mount.initd
}

set_mountinfo_result()
{
	MOUNTINFO_RESULT=$1
}

set_dev_is_mounted()
{
	set_mountinfo_result 0
}

set_fstabinfo_result()
{
	FSTABINFO_RESULT=$1
}

set_fstab_has_dev()
{
	set_fstabinfo_result 0
}

set_proc_filesystems()
{
	local fs
	for fs; do
		echo "$fs"
	done > "${SHUNIT_TMPDIR}"/proc-filesystems
}

setUp()
{
	RC_CMD=start
	rm -f "$SHUNIT_TMPDIR"/*.actual
	set_proc_filesystems tmpfs
	set_mountinfo_result 1
	set_fstabinfo_result 1
}

check_kv()
{
	local input="$1" actual= expected="$2"
	actual=$(KV_to_int "$input" 2>/dev/null)
	assertEquals "$?" "0"
	assertEquals "$expected" "$actual"
}

expect_fail_kv()
{
	local input="$1" actual=
	actual=$(KV_to_int "$input" 2>&1)
	assertEquals "$?" "1"
	assertEquals "" "$actual"
}

get_KV()
{
	echo 7
}

KV_to_int()
{
	echo 5
}

mount()
{
	echo "mount $@" >> "$SHUNIT_TMPDIR"/mount_call.actual
}

fstabinfo()
{
	echo "fstabinfo $@" >> "$SHUNIT_TMPDIR"/fstabinfo_call.actual
	return "${FSTABINFO_RESULT}"
}

mountinfo()
{
	echo "mountinfo $@" >> "$SHUNIT_TMPDIR"/mountinfo.actual
	return "${MOUNTINFO_RESULT}"
}

einfo()
{
	echo "einfo $@" >> "$SHUNIT_TMPDIR"/einfo.actual
}

ebegin()
{
:
}

eend()
{
:
}


testMountAlreadyMounted()
{
	set_dev_is_mounted

	mount_dev_directory

	assertFalse "fstabinfo must not be called" "[ -e '"$SHUNIT_TMPDIR"/fstabinfo_call.actual' ]"
	assertFalse "mount must not be called" "[ -e '"$SHUNIT_TMPDIR"/mount_call.actual' ]"
}

testMountUseFstab()
{
	set_fstab_has_dev

	mount_dev_directory

	assertTrue "fstabinfo must be called" "[ -e '"$SHUNIT_TMPDIR"/fstabinfo_call.actual' ]"
	assertFalse "mount must not be called" "[ -e '"$SHUNIT_TMPDIR"/mount_call.actual' ]"
}

testMountExplicitTmpfs()
{
	mount_dev_directory

	assertTrue "fstabinfo must be called" "[ -e '"$SHUNIT_TMPDIR"/fstabinfo_call.actual' ]"
	assertTrue "mount must be called" "[ -e '"$SHUNIT_TMPDIR"/mount_call.actual' ]"
	grep -q -- '-t tmpfs ' "$SHUNIT_TMPDIR"/mount_call.actual
	assertTrue "$?"
	grep -q -- '-t devtmpfs ' "$SHUNIT_TMPDIR"/mount_call.actual
	assertFalse "$?"
}

testMountExplicitDevtmpfs()
{
	set_proc_filesystems tmpfs devtmpfs

	mount_dev_directory

	assertTrue "fstabinfo must be called" "[ -e '"$SHUNIT_TMPDIR"/fstabinfo_call.actual' ]"
	assertTrue "mount must be called" "[ -e '"$SHUNIT_TMPDIR"/mount_call.actual' ]"
	grep -q -- '-t tmpfs ' "$SHUNIT_TMPDIR"/mount_call.actual
	assertFalse "$?"
	grep -q -- '-t devtmpfs ' "$SHUNIT_TMPDIR"/mount_call.actual
	assertTrue "$?"
}

. ./shunit2

