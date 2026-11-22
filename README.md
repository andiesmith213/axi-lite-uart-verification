# axi-lite-uart-verification
# Purpose 
This project verifies an open source AXI-Lite based UART utilizing UVM verification methodology.

# Status
Verification plan-- in progress

# Project Setup
## Simulating
This project utilizes the open-source simulation tool: Verilator. After meeting the prerequistes below, the command "make BUILD_VERILATOR" can be used to setup everything needed to use this simulator. Once the build is finished, run "make TEST_VERILATOR". This will run the basic_sanity_check test to ensure everything is configured properly. 

Prerequisetes:
