#
# Defines a Linux VM to be used e.g. for operating system courses at university.
#
# The directory that contains the Vagrantfile is available as a synced folder 
# within the VM at /home/vagrant/os.
#
# (c) 2019-2021 Josef Hammer
#
$script = <<-SCRIPT

cat << 'EOF' > /home/vagrant/.bash_os     # quote 'EOF' to avoid param expansion in the here-document

# make(): If the current directory does not contain a Makefile, 
#         a default Makefile is used as a fallback.
#
make() {
    MAKE=`which make`
    MAKEFILE="/home/vagrant/os/Makefile-c-generic-analysis"

    if [ -f makefile ] || [ -f Makefile ];
    then
        "$MAKE" "$@"
    else 
        echo "** Makefile: $MAKEFILE **"
        "$MAKE" -f "$MAKEFILE" "$@"
    fi
}

EOF

echo "" >> /home/vagrant/.bashrc
echo "source /home/vagrant/.bash_os" >> /home/vagrant/.bashrc
SCRIPT


Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder ".", "/home/vagrant/os"

  config.vm.provider 'virtualbox' do |vb|
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]  # decrease time resync threshold
  end

  config.vm.provision "shell",
    inline: "sudo apt update"
    
  config.vm.provision "shell",
    inline: "sudo apt -y install build-essential gdb valgrind linux-headers-$(uname -r) mlocate manpages-dev manpages-posix-dev clang clang-tidy cppcheck clang-format"
    # includes 'clang' just so clang-tidy can find the system headers
    # mlocate for locate + updatedb

  config.vm.provision "shell",
    inline: "sudo updatedb"  # to be able to 'locate' the new kernel sources

  config.vm.provision "shell",
    inline: "sudo sysctl -w kernel.core_pattern=core.%p.%t"  # save core dumps in the current directory

  config.vm.provision "shell", 
    inline: $script

end
