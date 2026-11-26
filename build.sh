#!/bin/bash

function check_env {
    #TODO: source set_env script
    #FIXME: this should check that the directories are actually there, not just that the variable is not empty
    #check that environment variables were set. If not, stop execution
    if [ -z $VERILATOR_PATH ] || [ -z $REPO_ROOT ] || [ -z $UVM_HOME ]; then 
        echo "Exiting script; one or more environment variables was not set"
        return 0 
    fi
}

#building Verilator
function build_verilator {
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
    cd $REPO_ROOT
}

#check verilator installation
function check_install {
    verilator_path=$(command -v verilator)
    if [ -n $verilator_path ]; then
        echo "Verilator was successfully installed at $verilator_path"
    else
        echo "There was a problem installing Verilator" 
    fi
}

check_env

build_verilator

check_install

#Appending scripts to PATH variable for easier simulation
export PATH=$PATH:$REPO_ROOT/verification/scripts

echo "******************************"
echo "*     Build Complete         *"
echo "******************************"