# axi-lite-uart-verification
# Purpose 
This project verifies an open source AXI-Lite based UART utilizing UVM verification methodology.

# Status
- [] Verification plan — <sub><strong>In progress</strong></sub>
- [] Environment setup — <sub><strong>In progress</strong></sub>

# Cloning this repo
Due to this project verifying separate open source hardware, the RTL is pulled in as a submodule. Therefore, when cloning this repo, use the --recurse-submodules argument to pull in the UART repo under the "hw" directory. 
> ```bash
> git clone --recurse-submodules https://github.com/andiesmith213/axi-lite-uart-verification
> ```

# Project Setup
## 1. Initialize virtual environment (recommended)
To prevent errors caused by version differences, it's recommended to create a virtual environment and install the package versions within the requirements.txt file. Note: this step is recommended but not necessary to run the simulations.
> ```bash 
> python3 -m venv .venv     #only needed first time
> source .venv/bin/activate
> python3 -m pip install -r requirements.txt
> ```
## 2. Installing Verilator (if not installed already)
This project utilizes the open-source simulation tool: Verilator. Any user looking to actually run simulations needs to clone the verilator git repo onto their computer if they haven't done so already. The simulator will be built automatically by make, no need to go through the build steps yourself. 
> ```bash
> cd path-where-verilator-install-desired
> git clone https://github.com/verilator/verilator
> ```
## 3. Instantiating git submodule (if not completed already)
If this project was cloned without pulling in the submodule, initialize the submodule now.
> ```bash
> git submodule update --init --recursive
> ```
## 4. Set environment variables
The make script needs to know where the verilator git repo exists on your computer to build all the dependencies. Therefore, the user needs to set an environment variable called VERILATOR_PATH. Additionally, to run simulations, the sim script needs to know the path to the repo and where UVM is installed on your computer.
>```bash 
> #bash
> export VERILATOR_PATH="from-root-to-path/verilator"
> export REPO_ROOT="from-root-to-path/axi-lite-uart-verification"
> export UVM_HOME="uvm-install-directory" #this should point to the directory that contains the uvm src folder 
>
> #csh
> setenv VERILATOR_PATH from-root-to-path/verilator
> setenv REPO_ROOT from-root-to-path/axi-lite-uart-verification
> setenc UVM_HOME uvm-install-directory #this should point to the directory that contains the uvm src folder 
>```
## 3. Run make
Once the environment variables are set, you are ready to run the make script. This will build Verilator using a set version, check that the installation was successful, and run a sanity check test to confirm everything is set up properly (if Verilator installation successful). 
> ```bash 
> make
> ```
# Simulating

