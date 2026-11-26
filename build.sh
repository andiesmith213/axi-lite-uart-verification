#!/bin/bash

#Declare global variable to check environment variables were correctly delcared
env_successful=0

function check_env {
    source set_env_var.sh
    #check that environment variables were set. If not, stop execution
    for var in VERILATOR_PATH REPO_ROOT UVM_HOME; do
        path=${!var-}
        if [[ -z "$path" || ! -d "$path" ]]; then
            printf 'Error: %s is unset, empty, or not a directory: %s\n' "$var" "$path" >&2
            env_successful=0
        else env_successful=1
        fi
    done
}

#building Verilator
function build_verilator {
    export VERILATOR_VERSION=5.054
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

#Run check_env function to see if other functions should be run
check_env

if [ $env_successful -eq 1 ]; then
    build_verilator
    check_install

    #Appending scripts to PATH variable for easier simulation
    export PATH=$PATH:$REPO_ROOT/verification/scripts

    echo "******************************"
    echo "*     Build Complete         *"
    echo "******************************"
fi