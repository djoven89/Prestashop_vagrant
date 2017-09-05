## Creación de una máquina virtual con ubuntu 16.04
## Con las siguientes configuraciones:
##	- Nombre de la máquina
##  - Tipo de box 
##	- Adaptador bridge (DHCP) eth0
##	- Carpeta compartida básica

Vagrant.configure("2") do |config|

## Configuraciones espcíficas de VirtualBox
	config.vm.provider "virtualbox" do |vbox|
		
		vbox.name = "vagrant_01"
		vbox.gui = false
		vbox.cpus = 1
		vbox.memory = 512

	end

	## Configuraciones del 'box'
	config.vm.box = "ubuntu/trusty64"
	config.vm.box_check_update = true
	config.vm.hostname = "prestashop"

	## Configuración de red
	config.vm.network "public_network", type: "dhcp", bridge: "eth0"
	#config.vm.network "private_network", ip: "192.168.50.1", netmask: "24", auto_config: true

	## Redirección de puertos (http) 
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

	## Detecta colisiones de redirecciones de puertos
  #  auto_correct: true

	## Configuración de la carpeta compartida
	config.vm.synced_folder ".", "/vagrant", disabled: false , 
		owner: "vagrant", group: "vagrant" 
		
	## Prueba del script de instalación de Debian
	config.vm.provision :shell, path: "lamp.sh", privileged: true
	config.vm.provision :shell, path: "prestashop.sh", privileged: true
	
	## Comprobando que los paquetes se instalaron
	config.vm.provision :shell, inline: <<-SHELL
		sudo netstat -putan | grep :80 --color && echo -e "\n"
		ip a s 
	SHELL


end
