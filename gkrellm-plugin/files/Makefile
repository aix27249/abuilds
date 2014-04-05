# Makefile for gkrelmm clipp - a plugin for gkrellm2
# Copyright (c) 2003-2006 Florian Bohrer <Florian.Bohrer@t-online.de>
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#

CFLAGS=-O2 -fPIC `pkg-config gtk+-2.0 --cflags`
LDFLAGS=-shared -W `pkg-config gtk+-2.0 --libs` 

clipp:  *.c    
	gcc $(CFLAGS) -c clipp.c 
	gcc $(LDFLAGS) -o clipp.so clipp.o
clean:
	rm *.o *.so
install:
	cp clipp.so /usr/lib/gkrellm2/plugins
	chmod 755 /usr/lib/gkrellm2/plugins/clipp.so
uninstall:
	rm /usr/lib/gkrellm2/plugins/clipp.so
