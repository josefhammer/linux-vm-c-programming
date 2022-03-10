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

#!/bin/bash
NAME=osdocker
RUNFILE=run-$NAME.sh
DOCKERFILE=https://raw.githubusercontent.com/josefhammer/linux-vm-c-programming/main/docker/Dockerfile
BUILDFILE=build-osdocker.sh
BUILDSRC=https://raw.githubusercontent.com/josefhammer/linux-vm-c-programming/main/docker/$BUILDFILE

# Download Dockerfile in case it does not exist yet
#
if [ ! -f "Dockerfile" ]
then
    echo "Downloading 'Dockerfile' from $DOCKERFILE."
    echo ""
    curl --silent --show-error --fail $DOCKERFILE -o Dockerfile || exit 1

    # Also download/update this build file (it might be piped from Curl) for easy updates
    #
    curl --silent --show-error --fail $BUILDSRC -o $BUILDFILE || exit 1
    chmod u+x "$BUILDFILE"
    #
    # Build script might have been updated -> execute the new one
    #
    exec "./$BUILDFILE"
else
    echo "*** For the latest version of $NAME, rename/delete 'Dockerfile' and run this script again. ***"
    echo ""
fi

# Delete previous image first to avoid images piling up
docker stop $NAME > /dev/null 2>&1
docker container rm $NAME > /dev/null 2>&1
docker image rm $NAME 2> /dev/null

# Build docker image 
#
docker build -t $NAME "$@" .

# Create launch script
#
cat << EOF > $RUNFILE

#!/bin/bash

if [[ \$# -gt 0 ]] && [[ \$1 == "destroy" ]]
then
    shift
    docker stop $NAME > /dev/null 2>&1
    docker container rm $NAME > /dev/null 2>&1
    echo ""
    echo "Container destroyed (call './$RUNFILE' to create a new one)."
    echo "To remove the image: 'docker image rm $NAME'"
    echo ""
    exit 0
fi

echo ""
echo "    Nothing is permanent. --Dalai Lama XIV"
echo "    (for a fresh start: './$RUNFILE destroy')"
echo ""

# Run in privileged mode first to set the core dump location
# (read-only otherwise, and we don't want to run in privileged mode by default)
#
# WARNING: This change affects all containers running the same kernel!
#          I.e., on MacOS, it will modify the LinuxKit kernel used by Docker.
#
# NOTE: Can be verified with 'cat /proc/sys/kernel/core_pattern'.
#
# Saves core dumps in the current directory.
#
docker run --privileged --rm -it $NAME sudo sysctl -w kernel.core_pattern=core.%p.%t > /dev/null 2>&1


# We want to enable multiple logins -> exec vs run
#
# Does the container exist already? 
#
if [ "\$(docker ps -a --filter name=^$NAME\$ | grep $NAME)" ]    # grep for exit code only
then
    docker start $NAME > /dev/null 2>&1     # just in case it was stopped
    docker exec -it $NAME /bin/bash
    docker stop $NAME > /dev/null 2>&1      # multiple logins: the first exit will stop the container
                                            # (to prevent a container running in the background)
else
    # No container yet -> create a new one
    #
    docker run -v \$(pwd):/home/vagrant/os "\$@" --hostname $NAME --init --name $NAME -it $NAME
fi

EOF
chmod u+x $RUNFILE

# Enjoy!
#
echo ""
echo "*** Execute './$RUNFILE' to run the docker container. ***"
echo ""
