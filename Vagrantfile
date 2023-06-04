#
# Defines a Linux VM to be used e.g. for operating system courses at university.
#
# The directory that contains the Vagrantfile is available as a synced folder 
# within the VM at /home/vagrant/os.
#
# (c) 2019-2023 Josef Hammer
# 
# Source: https://github.com/josefhammer/linux-vm-c-programming


Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder ".", "/home/vagrant/os"

  config.vm.provider 'virtualbox' do |vb|
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]  # decrease time resync threshold
  end

  config.vm.provision "shell",
    inline: "sudo apt update"
    
  config.vm.provision "shell",
    inline: "sudo apt -y install build-essential gdb valgrind mlocate manpages-dev manpages-posix-dev clang clang-tidy cppcheck clang-format"
    # includes 'clang' just so clang-tidy can find the system headers
    # mlocate for locate + updatedb

  config.vm.provision "shell",
    inline: "sudo apt -y install linux-headers-$(uname -r)"

  config.vm.provision "shell",
    inline: "sudo updatedb"  # to be able to 'locate' the new kernel sources

  config.vm.provision "shell", inline: <<-SHELL
    # disable default Ubuntu core dumps
    echo 'enabled=0' | sudo tee /etc/default/apport
    # save core dumps in the current directory (works until reboot)
    sudo sysctl -w 'kernel.core_pattern=core.%p.%t'
    # permanently set up core pattern
    echo 'kernel.core_pattern=core.%p.%t' | sudo tee /etc/sysctl.d/60-core-pattern.conf
  SHELL

  config.vm.provision "shell", 
    privileged: false,
    path: "https://raw.githubusercontent.com/josefhammer/linux-vm-c-programming/main/generic-makefiles/Makefile-macro.sh"

end
