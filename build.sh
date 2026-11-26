#!/bin/bash

#TODO: check that environment variables were set. If not, stop execution

#building Verilator
export VERILATOR_VERSION=5.054
echo $VERILATOR_PATH
echo $VERILATOR_VERSION
unset VERILATOR_ROOT
cd $VERILATOR_PATH
git checkout v$(VERILATOR_VERSION)
autoconf
./configure
make
sudo make install

#TODO: checking verilator installation
# @verilator_path="$$(command -v verilator)"; \
# if [ -n "$$verilator_path" ]; then \
#     echo "Verilator was successfully installed at $$verilator_path"; \
# else \
#     echo "There was a problem installing Verilator" >&2; \
#     exit 1; \
# fi

#Appending scripts to PATH variable for easier simulation
export PATH=$PATH:$REPO_ROOT/verification/scripts