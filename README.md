# **Prestashop 1.7 con Vagrant**

&nbsp;

#### ***Creación de un 'box' de Vagrant para usar prestashop 1.7 bajo un Ubuntu Server 14.04 con el software de virtualización VirtualBox.***

&nbsp;

El objetivo de este proyecto es facilitar la implementación del CMS ***prestashop*** para la realización de pruebas  y/o desarrollo.

***IMPORTANTE : *** No se han establecido medidas de seguridad a ningún servicio, por lo que es importante que no se use en producción sin haberlas añadido y probado.

&nbsp;

### **Requisitos para la ejecución de este 'box'**

**1.** Tener instalado Vagrant y Virtualbox.
**2.** Disponer de conexión a internet.



### **Software usado**

* Ubuntu Server 14.04 ( Trusty )
* Apache 2.4
* PHP 5.5
* Mysql server 5.6 
* Prestashop 1.7


### **Credenciales** 

* Usuario y contraseña del sistema operativo -> **vagrant** 

* Contraseña del usuario '**root**' de MYSQL -> **P@ssw0rd!**

* Nombre de la base de datos para prestashop -> **prestashop**

* Usuario y contraseña  para la DB de prestashop -> **prestauser** / **prestashop**

* Correo y contraseña del usuario administrador de prestashop -> **admin@mitienda.lan** / **@Dm1n!**

&nbsp;

## **Cómo usar este repositorio**

**1.** Descargar el repositorio en un directorio de tu sistema.

	wget https://github.com/djoven89/Prestashop_vagrant/archive/master.zip

**2.** Descomprimirlo.

	unzip master.zip

**3.** (Opcional) Cambiar valores de la configuración.

**4.** Iniciar el 'box'

	cd Prestashop_vagrant-master/  && vgrant up
 
**5.** Comprobar su funcionamiento.

	http://localhost:8080

**6.** (Opcional) Conectarse por ssh:

	vagrant ssh

En caso de querer borrar la máquina:

	vagrant destroy -f

Más información sobre el uso de los comandos de [Vagrant](https://www.vagrantup.com/docs/cli/)

------
# **Información y modificaciones**
------

### **Mejoras pendientes**

**1.** Añadir condicionales para evitar errores durante el proceso de instalación y configuración.

**2.** Mejorar la editabilidad de los valores importantes tales como contraseñas.

**3.** Añadir instrucciones para realizar backups sobre la base de datos.

&nbsp;

### **Configuración de Virtualbox (Vagrantfile)**


* 1GB de RAM.

* Tiene vinculada una carpeta compartida en el punto de montaje '/vagrant' del sistema operativo que está vinculado al directorio donde se ejecutó el 'vagrant up'.

* Se ha mapeado el puerto **80** del sistema operativo con el puerto **8080** de la máquina física donde está corriendo Virtualbox.

* Tiene 2 adaptadores de red, eth0 como '**NAT**' y eth1 como '**adaptador puente**'. 

* Se ejecutan dos script en orden.

* Si todo ha ido bien, antes de terminar con la instalación y configuración, se ejecutarán los dos últimos comandos.

El objetivo de tener el adaptador de red **eth1** es para permitir que la máquina sea accesible en la misma red en la que se se encuentre el propio host.

También se ha decidido ejecutar los dos scripts por separados en vez de todo en uno para diferenciar las partes de instalación y para que se puedan hacer modificaciones de forma más sencilla.

**[Aquí](https://www.vagrantup.com/docs/virtualbox/)** teneís más información sobre cómo configurar Vagrant.

&nbsp;

### **Modificaciones destacadas sobre los archivos de configuración**

Para el archivo '**Vagrantfile**':

* (línea 17) Modificar el adaptador de red.

* (línea 20) Cambiar el mapeo del puerto.

&nbsp;

En el archivo '**lamp.sh**' se podría hacerlo siguiente:

* Añadir o eliminar nuevo paquetes.

* (lineas 31 y 32)  Cambiar la contraseña de la base de datos.

&nbsp;

Y en el archivo '**prestashop.sh**' :

* (líneas 11-13) Modificaciones sobre las credenciales usadas para la base de datos de prestashop.

* (línea 21) Cambio de ubicación del directorio de prestashop.

* (línea 25) Modificación de los parámetros de la configuración de prestashop.
	* En especial el parámetro 'domain=' , en caso de tenerse un DNS configurado, sería buena idea añadir el subdominio en vez de una dirección IP.


* (línea 41-57) Modificación del VirtualHost de Apache para prestashop.

