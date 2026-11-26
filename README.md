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
## 4. Set environment variables and build
The build script needs to know where verilator, UVM and this repository exist on your computer to build all the dependencies. Therefore, the user needs to set a few environment variables.
First, add the paths from your computer to the set_env_var.sh file. 
> VERILATOR_PATH = the path from your computer to where your verilator repo was cloned
> REPO_ROOT = the path from your computer to where this repo is cloned
> UVM_HOME = the path from your computer to where the "src" directory is, likely under "uvm-core-[date of release]"
Then run this command:
>```bash 
> source build.sh
>```

# Simulating
If the build.sh was successful, the path within axi-lite-uart-verification was added to the shell's PATH variable. Therefore, as long as the build completed successfully, you can run the command below from any directory. This will compile and simulate the provided test. 
>```bash
> sim.sh [test-name]
>```
