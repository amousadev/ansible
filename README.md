### this repo explains how to install tomcat 8.5 , nagiosXI 5.11 and jenkins via ansible on centos and also configure tomcat for NAgios XI monitoring using Nagios XI API
##### infrastructure needed:
- two linux servers running centos 7, either VMs or physical, connected to the same network , one will be used as ansible control node and the other will be used as a managed node machine.

##### environment setup steps:
- setup hostnames for the two machines using the below command, here I will use hostnames "control" and "app04" for control node and managed node machines:

  - `hostnamectl set-hostname control`
  
  - `hostnamectl set-hostname app04` 
- ** setup network connectivity between the control node and the managed node **:
  1. login as the root user
  - edit the configuration files located under `/etc/sysconfig/network-scripts/ifcfg-enp0s3` in both machine to be like the below for both machines and assign different IP addresses for both.
```
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="static"
IPADDR="192.168.1.108"
NETMASK="255.255.255.0"
DNS="8.8.8.8"
GATEWAY="192.168.1.1"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp0s3"
UUID="e03b946e-8119-4138-b947-456cadf377d1"
DEVICE="enp0s3"
ONBOOT="yes"
```
  - apply the configuration by restarting network using command: ` systemctl restart network`
  - test conncetivity using `ping` command

- **Install ansible**:
  - login as root user on centos
  - install epel-release repo using command:  `yum install epel-release`
  - install ansible using command: `yum install ansible`
  
- **Setup SSH key authentication between control node and managed node**:
  1. login as ansible user to the control node machine and issue the following commands:
    - `ssh-keygen -t rsa`
    - `ssh-copy-id app04`
    - supply the password for ansible user for the SSH key to be copied to the managed node machine.
    - try doing ssh to the remote machine, you should be able to login without asking for password.
- **edit hosts file:**
 - edit `/etc/hosts` file on the control node to include hostname of the managed node bu adding below line:

      192.168.1.108 app04
- create file called `inv` for anible invntory to include app04 host :
        
        [webservers]
        app04
- **product sources:**
  - get product sources from following links: [tomcat 8.5](https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.93/bin/apache-tomcat-8.5.93.tar.gz) , [nagiosXI 5.11](https://assets.nagios.com/downloads/get_download.php?product_download=nagiosxi-source-64), [jdk-21](https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz), [jenkins-2.387](https://ftp.belnet.be/mirror/jenkins/war-stable/2.387.1/jenkins.war)
  - copy these sources to `/home/ansible/sources/` on the control node.
  
- **run installation and configuration playbooks:**
  
  - `installSoftware.yml` :&nbsp; this playbook will install tomcat, nagios XI, jenkins, Java and open firewall ports for tomcat server
  - `ConfigureTomcat.yml`: &nbsp; this playbook will do the following configuration to Tomcat:
     1. configure tomcat ports.
     - allow access to tomcat manager from diffrent source IP addresses.
     - allow access for tomcat user to manager application.
     - configure tomcat cache size so that large application like jenkins can run.
     - configure JMX and RMI for nagiosXI monitoring.
     - create some linux command aliases to manage tomcat.
     - start tomcat
- **complete nagios XI installation:**
  - access nagios GUI from `http://{manged-node-IP}/nagiosxi` &nbsp; and complete installation and selecting license type, nagiosadmin user and password.
- **complete jenkins installation:**
   - access jenkins through `http://{manged-node-IP}:9090/jenkins/` and complete installation for jenkins by creating admin username and supplying secret key that can be found in tomcat catalina.out log file.
- **create jenkins pipeline:**
  -  create jenkins pipeline using `jenkinsfile` to build and deploy sample pet-clinic application on tomcat server.
  - access pet-clinic application at `http://{manged-node-IP}:9090/pet-clinic/` 
  
  
- **configure nagios XI to monitor tomcat server:**
  - get Nagios XI API key by loging into GUI and clicking on the username on the right top corner
  - edit `createTomcatMonitoringService.sh`by replacing API key you got from nagiox GUI.
  - run `configureNagios.yml` playbook to automatically add monitoring service for tomcat instance using nagios XI API.
  
you can now access nagios GUI and go to operation center and navigate to tomcatMonitoringService to view monitoring data for tomcat
  



