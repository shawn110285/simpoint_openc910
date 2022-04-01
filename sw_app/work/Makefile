#/*Copyright 2019-2021 T-Head Semiconductor Co., Ltd.
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#*/

# set the toolchain dir according to your installation
TOOL_EXTENSION := /opt/riscv64-tools-install/bin

CC      = ${TOOL_EXTENSION}/riscv64-unknown-elf-gcc
AS      = ${TOOL_EXTENSION}/riscv64-unknown-elf-as
LINK    = ${TOOL_EXTENSION}/riscv64-unknown-elf-ld
OBJDUMP = ${TOOL_EXTENSION}/riscv64-unknown-elf-objdump
OBJCOPY = ${TOOL_EXTENSION}/riscv64-unknown-elf-objcopy
CONVERT	=../bin/Srec2vmem

SSRC = $(wildcard *.S)
sSRC = $(wildcard *.s)
CSRC = $(wildcard *.c)

OBJECTS = $(SSRC:%.S=%.o) $(sSRC:%.s=%.o) $(CSRC:%.c=%.o)

FLAG_MARCH += -march=rv64imafdc
FLAG_ABI   = -mabi=lp64d

CFLAGS = ${FLAG_MARCH} ${FLAG_ABI}

ifeq (${CASENAME}, coremark)
  CFLAGS += -c -O3 -mtune=c910 -static -funroll-all-loops -finline-limit=500 -fgcse-sm -fno-schedule-insns --param max-rtl-if-conversion-unpredictable-cost=100 -msignedness-cmpiv -fno-code-hoisting -mno-thread-jumps1 -mno-iv-adjust-addr-cost -mno-expand-split-imm -DITERATIONS=10000
  # CFLAGS += -c -v -funroll-all-loops -finline-limit=500 -fgcse-sm -fno-schedule-insns --param max-rtl-if-conversion-unpredictable-cost=100 -fno-code-hoisting -mno-thread-jumps1 -mno-iv-adjust-addr-cost -DITERATIONS=10000 -O3 -static -mbit-translate
else
  CFLAGS += -c -O2
endif

CFLAGS += --specs=nano.specs

LINKFLAGS = -Tlinker.lcf -nostartfiles ${FLAG_MARCH} ${FLAG_ABI}

# LINKLIBS  = -L${TOOL_PATH}/lib/gcc/riscv64-unknown-elf/8.1.0/rv32imac
# LINKLIBS += -L${TOOL_PATH}/riscv64-unknown-elf/lib/rv32imac
# LINKLIBS += -L${TOOL_PATH}/riscv32-unknown-elf/lib

LINKLIBS = -lc -lgcc

OBJDUMPFLAGS = -S -Mnumeric

HEXFLAGS	= -O srec

%.o : %.c
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.s
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.S
	${CC} -c ${CFLAGS} -o $@ $<


${FILE}.obj : ${FILE}.elf
	${OBJDUMP} ${OBJDUMPFLAGS} $< > $@

${FILE}.elf : ${OBJECTS} linker.lcf
	${CC} ${LINKFLAGS} ${LINKLIBS} ${OBJECTS} -o $@ -lm

${FILE}.bin: ${FILE}.elf
	$(OBJCOPY) -O binary $^ $@

${FILE}.vmem: ${FILE}.bin
	srec_cat $^ -binary -offset 0x0000 -byte-swap 4 -o $@ -vmem

${FILE}.dump: ${FILE}.elf
	$(OBJDUMP) --disassemble-all $< > $@

INST_HEX = ${FILE}_inst.hex
DATA_HEX = ${FILE}_data.hex
FILE_HEX = ${FILE}.hex

${FILE}.hex : ${FILE}.elf
	${OBJCOPY} ${HEXFLAGS} $< ${INST_HEX} -j .text*  -j .rodata* -j .eh_frame*
	${OBJCOPY} ${HEXFLAGS} $< ${DATA_HEX} -j .data*  -j .bss -j .COMMON
	${OBJCOPY} ${HEXFLAGS} $< $@

INST_PAT = inst.pat
DATA_PAT = data.pat
FILE_PAT = case.pat

%.pat	: %.hex
	rm -f *.pat
	${CONVERT} ${INST_HEX} ${INST_PAT}
	${CONVERT} ${DATA_HEX} ${DATA_PAT}
	${CONVERT} ${FILE_HEX} ${FILE_PAT}


#--------------------------------------------------------------------
# target setting
.PHONY :all
all : ${FILE}.pat ${FILE}.hex ${FILE}.elf ${FILE}.obj ${FILE}.bin ${FILE}.vmem ${FILE}.dump

#---------------------------------------------------------------------
# clean some medium code and .pat
.PHONY :clean
clean:
	rm -rf *.o *.pat *.elf *.obj *.hex

