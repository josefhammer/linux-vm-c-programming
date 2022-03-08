#
# Installs a 'make' bash macro that uses a predefined Makefile if none is found 
# in the current folder. 
#
# To be used e.g. for operating system / C programming courses at university.
#
# (c) 2019-2022 Josef Hammer
# 
# Source: https://github.com/josefhammer/linux-vm-c-programming


#!/bin/bash

USER=`whoami`
FILE=/home/$USER/.bash_os

cat << 'EOF' > $FILE     # quote 'EOF' to avoid param expansion in the here-document

# make(): If the current directory does not contain a Makefile, 
#         a default Makefile is used as a fallback.
#
make() {
    MAKE=`which make`
    USER=`whoami`
    MAKEFILE="/home/$USER/.Makefile-c-generic-analysis"

    if [ -f makefile ] || [ -f Makefile ];
    then
        "$MAKE" "$@"
    else 
        echo "** Makefile: $MAKEFILE **"
        "$MAKE" -f "$MAKEFILE" "$@"
    fi
}

EOF

echo "" >> /home/$USER/.bashrc
echo "source $FILE" >> /home/$USER/.bashrc

# Copy generic Makefile to user home
wget --quiet -O /home/$USER/.Makefile-c-generic-analysis https://raw.githubusercontent.com/josefhammer/linux-vm-c-programming/main/generic-makefiles/Makefile-c-generic-analysis
# Copy .clang-format to user home
wget --quiet -O /home/$USER/.clang-format https://raw.githubusercontent.com/josefhammer/linux-vm-c-programming/main/generic-makefiles/.clang-format
