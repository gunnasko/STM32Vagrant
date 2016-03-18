require_relative 'lib/better_usb.rb'
require_relative 'lib/calculate_hardware.rb'
require_relative 'lib/os_detector.rb'

if ARGV[0] == "up" then
  has_installed_plugins = false

  unless Vagrant.has_plugin?("vagrant-vbguest")
    system("vagrant plugin install vagrant-vbguest")
    has_installed_plugins = true
  end
  
  if has_installed_plugins then
    puts "Vagrant plugins were installed. Please run vagrant up again to install the VM"
    exit
  end

end

vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure(2) do |config|
  # Ubuntu 14.04 LTS
  config.vm.box = "ubuntu/trusty64"
  
  config.vm.provider :virtualbox do |vb|
    # Tell VirtualBox that we're expecting a UI for the VM
    vb.gui = true
    
    # Enable sharing the clipboard
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]

    # Set # of CPUs and the amount of RAM, in MB, that the VM should allocate for itself, from the host
    CalculateHardware.set_minimum_cpu_and_memory(vb, 2, 2048)

    # Set the amount of RAM that the virtual graphics card should have
    vb.customize ["modifyvm", :id, "--vram", "128"]

    # Enable the use of hardware virtualization extensions (Intel VT-x or AMD-V) in the processor of your host system
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]

    # Enable, if Guest Additions are installed, whether hardware 3D acceleration should be available
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    
    vb.customize ["modifyvm", :id, "--usb", "on", "--usbehci", "on"]
    # Setup rule to automatically attach ST Link v2.1 Debugger when plugging in Nucleo board
    BetterUSB.usbfilter_add(vb, "0x0483", "0x374b", "ST Link v2.1 Nucleo")

  end

  
  #
  # bootstrap.sh or provision-custom.sh
  #
  # By default, our Vagrantfile is set to use the bootstrap.sh bash script located in the
  # provision directory. If it is detected that a provision-custom.sh script has been
  # created, it is run as a replacement. This is an opportunity to replace the entirety
  # of the provisioning provided by the default bootstrap.sh.
  #
  if File.exist?(File.join(vagrant_dir,'provision','provision-custom.sh')) then
    config.vm.provision :shell, path: File.join( "provision", "provision-custom.sh" )
  else
    config.vm.provision :shell, path: File.join( "provision", "bootstrap.sh" )
  end

  #
  # provision-as-vagrant-user.sh
  #
  # provision-as-vagrant-user.sh is a post-provision hook to run commands as the vagrant user on the system.
  #
  if File.exist?(File.join(vagrant_dir,'provision','provision-as-vagrant-user.sh')) then
    config.vm.provision :shell, path: File.join( "provision", "provision-as-vagrant-user.sh" ), :privileged => false
  end
end
