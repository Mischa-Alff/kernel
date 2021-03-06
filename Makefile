all: kernel.iso	

ARCH=x86_64
SRC_DIR = src
INC_DIR = include
KERNEL_DIR = kernel
KERNEL_PATH = ${SRC_DIR}/${KERNEL_DIR}
INCLUDE_DIRS = src/ include/
KERNEL_INCLUDE_DIRS = ${INCLUDE_DIRS} include/kernel/
INCLUDE_ARGS = ${foreach dir, ${INCLUDE_DIRS}, -I${dir}}
.SUFFIXES: .asm
 
ifeq ($(ARCH), "64")
	override ARCH = x86_64
endif
ifeq ($(ARCH), "x86-64")
	override ARCH = x86_64
endif
ifeq ($(ARCH), "32")
	override ARCH = x86_32
endif
ifeq ($(ARCH), "x86-32")
	override ARCH = x86_32
endif
ifeq ($(ARCH), "x86")
	override ARCH = x86_64
endif

include platforms/$(ARCH)/$(ARCH).mk

kernel.sym: kernel.bin
	nm $^ | grep " . " | awk '{ print $1" "$3}' > @

symbols: kernel.sym

stats:
	cloc --yaml . | grep -E 'Assembly:|C:|C\+\+:' -A 4 | sed 's/nFiles/files/'
	echo -n "Total: " && cloc --yaml . | grep -E 'SUM:' -A 4 | grep 'code: ' | sed 's/.*code: //g;s/$$/ SLoC/g'
.PHONY : stats
.SILENT : stats

clean:
	for f ; \
	do \
		$(RM) $$f; \
	done <<< `find . -name \.o`;
.PHONY : clean
