# axi-lite-uart-verification
# Purpose 
This project verifies an open source AXI-Lite based UART utilizing UVM verification methodology.

# Status
Verification plan-- in progress

# Project Setup
## 1. Initialize virtual environment (recommended)
To prevent errors caused by version differences, it's recommended to create a virtual environment and install the package versions within the requirements.txt file. Note: this step is recommended but not necessary to run the simulations.
> ```bash 
> python3 -m venv .venv     #only needed first time
> source .venv/bin/activate
> python3 -m pip install -r requirements.txt
> ```
## 2. Installing Verilator (if not installed already)
This project utilizes the open-source simulation tool: Verilator. Any user looking to actually run simulations needs to clone the verilator git repo onto their computer if they haven't done so already. 
> ```bash
> cd path-where-verilator-install
> git clone https://github.com/verilator/verilator
> ```
## 2. Set environment variables
The make script needs to know where the verilator git repo exists on your computer to build all the dependencies. Therefore, the user needs to set an environment variable called VERILATOR_PATH. Additionally, to run simulations, the sim script needs to know the path to the repo
>```bash 
> #bash
> export VERILATOR_PATH="from-root-to-path/verilator"
> export REPO_ROOT="from-root-to-path/axi-lite-uart-verification"
>
> #csh
> setenv VERILATOR_PATH from-root-to-path/verilator
> setenv REPO_ROOT from-root-to-path/axi-lite-uart-verification
>```
## 3. Run make
Once the environment variables are set, you are ready to run the make script. This will build Verilator using a set version, check that the installation was successful, and run a sanity check test to confirm everything is set up properly (if Verilator installation successful). 
> ```bash 
> make
> ```
# Simulating

