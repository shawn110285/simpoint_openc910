# -------------------------------------------------------------------------
# Author:  shawn Liu
# E-mail:  shawn110285@gmail.com
# --------------------------------------------------------------------------

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

CC      = g++
AR      = ar
ARFLAGS = -r
LD      = ld
LDFLAGS =

# the linked lib
STANDARD_LIBS     =
STANDARD_LIBS_DIR =

MAKE   = make
# the rm comand
RM = rm -rf

LOCAL_LIBS := ./sim/obj_dir/libtb.a ./rtl/obj_dir/Vtop__ALL.a

# the bin file name
target = openc910_tb

# the dependant libs
rtl/obj_dir/Vtop__ALL.a:
	$(MAKE) -C ./rtl -f rtl.mk all

sim/obj_dir/libtb.a: ./rtl/obj_dir/Vtop__ALL.a
	$(MAKE) -C ./sim -f sim.mk all

# All Target
all: $(target)

# link the libs into a executable bin file  # $(STANDARD_LIBS) $(LOCAL_LIBS)
$(target): $(LOCAL_LIBS)
	@echo 'Building target: $@'
	@echo 'Invoking: gcc C Linker'
	$(CC) $(STANDARD_LIBS_DIR) -o $(target) $(STANDARD_LIBS) $(LOCAL_LIBS) $(LOCAL_LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
# clean the sub dir's object and libs
	$(MAKE) -C ./sim -f sim.mk clean
	$(MAKE) -C ./rtl -f rtl.mk clean

# clean the target
	$(RM) $(target)
	@echo ' '

.PHONY: all clean
