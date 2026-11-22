# axi-lite-uart-verification
# Purpose 
This project verifies an open source AXI-Lite based UART utilizing UVM verification methodology.

# Status
Verification plan-- in progress

# Project Setup
## Initialize virtual environment (recommended)
To prevent errors caused by version differences, it's recommended to create a virtual environment and install the package versions within the requirements.txt file. (This guide assumes the user is setting up and using a bash shell)
> python -m venv .venv
> source .venv/bin/activate
> python -m pip install -r requirements.txt
## Simulating
This project utilizes the open-source simulation tool: Verilator. After meeting the prerequistes below, the command "make BUILD_VERILATOR" can be used to setup everything needed to use this simulator. Once the build is finished, run "make TEST_VERILATOR". This will run the basic_sanity_check test to ensure everything is configured properly. 

Prerequisetes:
The make script needs to know where the verilator git repo exists on your computer to build all the dependencies. Therefore, the user needs to set an environment variable called VERILATOR_PATH.
