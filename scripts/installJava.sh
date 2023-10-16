#!/bin/bash
#create user step
if [ -z $1 ];then
   echo "syntax : installJava.sh USERNAME"
else
 tar -zxvf /home/ansible/sources/jdk-21_linux-x64_bin.tar.gz -C /home/$1 >> /dev/null
 if [ $? == 0 ];then
  echo " JAVA is installed successfully in user home directory /home/$1 "
 fi
 echo "export JAVA_HOME=/home/$1/jdk-21" >> /home/$1/.bash_profile
 sed -i "/PATH=/c\PATH=\/home\/$1\/jdk-21\/bin/\:\$PATH\:\$HOME/.local/bin\:\$HOME/bin" /home/$1/.bash_profile
 if [ $? == 0 ];then
 echo " JAVA_HOME and PATH env. variables are set and JAVA will be available to the user in the next logon"
 fi
fi

