Vagrant.configure("2") do |config|

## Configuración específica para VirtualBox
   config.vm.provider "virtualbox" do |vbox|		
      vbox.name = "Prestashop"
      vbox.gui = false  
      vbox.cpus = 1
      vbox.memory = 1024
   end

## Configuración del 'box'
   config.vm.box = "ubuntu/trusty64"
   config.vm.box_check_update = true
   config.vm.hostname = "prestashop"

## Configuración de red
   config.vm.network "public_network", type: "dhcp", bridge: "eth0"

## Redirección de puertos (http) 
   config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

## Configuración de la carpeta compartida
   config.vm.synced_folder ".", "/vagrant", disabled: false , owner: "vagrant", group: "vagrant" 
		
## Instalación del software via scripts
   config.vm.provision :shell, path: "lamp.sh", privileged: true
   config.vm.provision :shell, path: "prestashop.sh", privileged: true
	
## 'Output' final tras la instalación y configuración del 'box'
   config.vm.provision :shell, inline: <<-SHELL
      sudo ss -tupan | egrep '(:80|:3306)' --color && echo -e "\n"
      ip -4 a 
   SHELL

end
