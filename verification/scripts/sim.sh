#verilator --binary --timing --trace-vcd -f $REPO_ROOT/verification/includes/rtl.f -f $REPO_ROOT/verification/includes/ver.f --top-module testbench ../basic_sanity_check.sv 

#INstructions for compiling and running a UVM test using Verilator:
# export REPO_ROOT=$PWD
# export UVM_HOME=/path/to/uvm

# verilator --binary --timing --trace-vcd \
#   --top-module testbench \
#   -Mdir verification/tb/obj_dir \
#   -I"$UVM_HOME/src" \
#   -f verification/includes/rtl.f \
#   "$UVM_HOME/src/uvm_pkg.sv" \
#   "$UVM_HOME/src/dpi/uvm_dpi.cc" \
#   verification/tb/testbench.sv \
#   verification/tests/basic_sanity_check.sv

# ./verification/tb/obj_dir/Vtestbench \
#   +UVM_TESTNAME=basic_sanity_check \
#   +UVM_VERBOSITY=UVM_LOW

#!/bin/bash
verilator --binary --timing --trace-vcd --top-module testbench \
    -f $REPO_ROOT/verification/includes/rtl.f \
    -f $REPO_ROOT/verification/includes/ver.f 

