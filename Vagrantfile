Vagrant.configure("2") do |config|
  config.vm.box = "elipwns/vulkan-gamedev-windows"
  
  config.vm.provider "hyperv" do |hv|
    hv.memory = 16384
    hv.cpus = 8
    hv.enable_virtualization_extensions = true
    hv.vm_integration_services = {
      guest_service_interface: true,
      heartbeat: true,
      key_value_pair_exchange: true,
      shutdown: true,
      time_synchronization: true,
      vss: true
    }
  end
  
  config.vm.communicator = "winrm"
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"
  config.winrm.transport = :plaintext
  config.winrm.basic_auth_only = true
  
  config.vm.network "forwarded_port", guest: 3389, host: 33389, id: "rdp", auto_correct: true
  config.vm.network "forwarded_port", guest: 5985, host: 55985, id: "winrm", auto_correct: true
end