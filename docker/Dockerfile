#
# Creates a Linux Docker container to be used similar to a VM 
# e.g. for C programming courses at university.
#
# The current working directory is available within the container at 
# /home/vagrant/os.
#
# (c) 2022 Josef Hammer
# 
# Source: https://github.com/josefhammer/linux-vm-c-programming


FROM ubuntu:20.04
ENV container docker
# Avoid questions on apt install
ARG DEBIAN_FRONTEND=noninteractive

RUN apt -y update
# > This system has been minimized by removing packages and content that are
# > not required on a system that users do not log into.
# > To restore this content, including manpages, you can run the 'unminimize'
# > command. You will still need to ensure the 'man-db' package is installed.
RUN yes | unminimize

# Install C programming tools
RUN apt -y install build-essential gdb valgrind mlocate manpages-dev manpages-posix-dev clang clang-tidy cppcheck clang-format
# includes 'clang' just so clang-tidy can find the system headers
# mlocate for locate + updatedb
RUN apt -y install linux-virtual

# Install common stuff that is missing
RUN apt -y install sudo wget curl vim nano man-db less rsyslog

# Add vagrant user
RUN adduser --disabled-password --gecos '' vagrant
RUN adduser vagrant sudo
RUN usermod -a -G adm vagrant
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# .bashrc fine-tuning
RUN sed -i -e 's/#force_color_prompt=yes/force_color_prompt=yes/' /home/vagrant/.bashrc
RUN sed -i -e "s/alias ll='ls -alF'/alias ll='ls -lF'/" /home/vagrant/.bashrc

# Run RSyslog on login (ignore error if running already)
RUN echo 'sudo rsyslogd 2>/dev/null' >> /home/vagrant/.profile 

USER vagrant
WORKDIR /home/vagrant/

# Run sudo once just to get rid of the following welcome message:
# > To run a command as administrator (user "root"), use "sudo <command>".
# > See "man sudo_root" for details.
RUN sudo echo ""

# Install generic makefile
RUN wget --quiet -O - https://raw.githubusercontent.com/josefhammer/linux-vm-c-programming/main/generic-makefiles/Makefile-macro.sh | bash

STOPSIGNAL SIGKILL

# -l ... login shell -> .profile will be executed
# -i ... interactive shell -> do not start another one
ENTRYPOINT [ "/bin/bash", "-li" ]
