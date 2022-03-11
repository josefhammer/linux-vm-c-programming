# Linux VM + generic Makefile for C programming


- Defines a **Virtual Machine with Linux** (Ubuntu) to be used e.g. for operating system courses at university. 
- The directory that contains the Vagrantfile (= **root working directory**) is available as a **shared folder** within the VM at `/home/vagrant/os`.
- Alternatively, a **Docker container** is available (e.g., to be used with Apple’s M1 chip).
- A **generic Makefile** and tools for static code analysis (C language) are provided.
- A **generic Makefile for kernel modules** is provided as well.


## Getting Started

- Install **Virtualbox** 
    - Install the software only – no virtual machine.
        - For Apple users: Virtualbox **does not work** (yet) **with the M1 chip**. 
          Alternative solutions (not automated with Vagrant) include [Parallels Desktop](https://www.parallels.com/) and [UTM](https://mac.getutm.app/) or the [Docker solution below](#linux-virtual-machine-with-docker).
    - https://www.virtualbox.org/
- Install **Vagrant**
    - https://www.vagrantup.com/
- Download/copy this file to your **root working directory**
    - `Vagrantfile`
- (Re-) **Provision** the Vagrant VM (in your root working directory)
    - `vagrant up --provision`


## Linux Virtual Machine with Vagrant


### Usage

- On the command line in the `Vagrantfile` folder
   
        vagrant up
        vagrant ssh
 
- The folder with the `Vagrantfile` is shared

        cd ~/os

- When you do not need the VM

        vagrant suspend


### Troubleshooting

If you get the following error message:

    ==> Mounting NFS shared folders...
    ...
    mount.nfs: requested NFS version or transport protocol is not supported

Try this solution:

- edit `/etc/hosts` on your host system
- add `127.0.0.1 localhost` (in case this line is missing)


## Linux “Virtual Machine” with Docker

- This solution is intended for students with an Apple M1 chip who cannot use Virtualbox (yet).
- A Docker container is not a virtual machine, and **Kernel module development** is **not possible**.
    - _It would be possible in `privileged mode`, but there are no header files available for the LinuxKit kernel used on MacOS (March 2022)_.

### Installation

- Install **Docker Desktop** 
    - https://docs.docker.com/desktop/mac/apple-silicon/
- Run **Docker.app**
    - Grant privileges if necessary.
    - Docker Desktop must be running when using the container.
- Open a shell with your **root working directory**
    - The folder must not contain a file named `Dockerfile`.
- Run this command in your **root working directory**
    ```
    curl https://raw.githubusercontent.com/josefhammer/linux-vm-c-programming/main/docker/build-osdocker.sh | bash
    ```

### Usage

- Run the newly created **launch script** in your **root working directory**

        ./run-osdocker.sh

    - This folder will be available within the container at `/home/vagrant/os`.
    - Can be run multiple times if more than one shell in parallel is needed.
        - The first one to `exit` will stop the container.
    - _The script has been designed to make the container feel like a Vagrant virtual machine – this is not how one would typically use containers._

## Generic Makefile with static code analysis

To guarantee that the static analysis is performed on each run, all `*.c` files will be compiled regardless of whether they were changed or not. I.e., the typical Make optimization to compile only changed files is disabled (the script is intended for student assignments where build performance is not of major importance).

__Targets__ 

Target | Description
--- | ---
**format** |	Auto-format all source files
**clean** | Remove binary program and all temp files
**all** | Full build
**test** | Run program with Valgrind


__Limitations__ 

Can link a single program per folder only.

__Requirements__ 

`sudo apt -y install build-essential valgrind clang clang-format clang-tidy cppcheck`


### Usage

In the directory with your source file(s) within the VM:

    make
    make test (in case no command-line arguments are required for your program)
    make clean


### Notes

- one program per folder only
- if you have your own Makefile in the folder, yours will be used
- no need to copy the Makefile (renamed to `Makefile`!) into your source folder **if** the [make-macro installation script](generic-makefiles/Makefile-macro.sh) has been run (e.g., in the Vagrant virtual machine)


## Auto-format your source files

In the directory with your source file(s) within the VM

    make format
    
    
### Notes

- uses **clang-format** with a style based on WebKit style
- you may adapt `.clang-format` according to your preferences
- sections can be excluded using `// clang-format off|on`
- many editors/IDEs like Atom and Visual Studio Code have integrations/features that allow to auto-format code (i.e., you won’t have to use `make format`)


### Auto-Format with Visual Studio Code

1. Install the **C++ Extension** by Microsoft

2. Preferences --> Settings --> search for “format”
    - **Editor:** activate “Format On Save”
    - **C/C++:** `Clang_format_style` = `file` 
        - will format only if a `.clang-format` is present in any parent directory
    - **C/C++:** `Clang_format_fallback` = `WebKit` 
        - will also format if no `.clang-format` is present
        - if `None` nothing will be done without a `.clang-format` file present


## Generic Makefile for kernel modules

This Makefile copies a single `*.c` file to a temp folder, compiles it to a kernel module, and copies the resulting kernel object file back to the current folder. This approach keeps the current folder clean of any temp files.


### Usage

Copy the file [Makefile-kernel-module](generic-makefiles/Makefile-kernel-module) to your source folder and **rename it** to `Makefile` or `makefile`.

In the directory with your source file(s) within the VM:

    make
    make clean

__Attention__

The provided Makefile must be renamed exactly as mentioned above (no extension!); otherwise, the generic Makefile for regular C programs will be used!

__Limitations__ 

The folder must contain a single *.c file only.


## License

This project is licensed under the [MIT License](LICENSE.md).

