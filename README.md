# Linux VM + generic Makefile for C programming


- Defines a **Virtual Machine with Linux** (Ubuntu) to be used e.g. for operating system courses at university. 
- The directory that contains the Vagrantfile is available as a **shared folder** within the VM at `/home/vagrant/os`.
- A **generic Makefile** and tools for static code analysis (C language) is provided.


## Getting Started

- Install **Virtualbox**
    - https://www.virtualbox.org/
- Install **Vagrant**
    - https://www.vagrantup.com/
- Download/copy these files to your **root working directory**
    - `Vagrantfile`
    - `Makefile-c-generic-analysis`
    - `.clang-format`
- (Re-) **Provision** the Vagrant VM
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
    make test (in case no command line arguments are required for your program)
    make clean

### Notes

- one program per folder only
- no need to copy the Makefile into your source folder
- if you have your own Makefile in the folder, yours will be used


## Auto-format your source files

In the directory with your source file(s) within the VM

    make format
    
### Notes

- uses **clang-format** with a style based on WebKit style
- you may adapt `.clang-format` according to your preferences
- sections can be excluded using `// clang-format off|on`
- many editors/IDEs like Atom and Visual Studio Code have integrations/features that allow to auto-format code (i.e. you won’t have to use `make format`)


### Auto-Format with Visual Studio Code

1. Install the **C++ Extension** by Microsoft

2. Preferences --> Settings --> search for “format”
    - **Editor:** activate “Format On Save”
    - **C/C++:** `Clang_format_style` = `file` 
        - will format only if a `.clang-format` is present in any parent directory
    - **C/C++:** `Clang_format_fallback` = `WebKit` 
        - will also format if no `.clang-format` is present
        - if `None` nothing will be done without a `.clang-format` file present


## License

This project is licensed under the [MIT License](LICENSE.md).

