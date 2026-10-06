# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 600

  config.vm.define :srv1 do |srv1|
    srv1.vm.box = "bento/ubuntu-22.04"
    srv1.vm.network :private_network, ip: "192.168.50.3"
    srv1.vm.hostname = "srv1-2230021"
  end

  config.vm.define :srv2 do |srv2|
    srv2.vm.box = "bento/ubuntu-22.04"
    srv2.vm.network :private_network, ip: "192.168.50.2"
    srv2.vm.hostname = "srv2-2230021"
  end

  config.vm.define :cliente do |cliente|
    cliente.vm.box = "bento/ubuntu-22.04"
    cliente.vm.network :private_network, ip: "192.168.50.4"
    cliente.vm.hostname = "cliente-2230021"
  end
end
