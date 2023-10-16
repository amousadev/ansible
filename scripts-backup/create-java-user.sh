#!/bin/bash
#create user step
if [ -z $1 ] | [ -z $2 ];then
 echo "please enter both username and password"
 exit 2
elif [ $1 = "-h" ];then
   echo "syntax : create-java-user.sh USERNAME PASSWORD"
else
 useradd $1 -m
 echo $2 | passwd --stdin $1
 if [ $? == 0 ];then
   echo " user $1 is created successfully "
 fi
 tar -zxvf /home/ansible/sources/jdk-21_linux-x64_bin.tar.gz -C /home/$1 >> /dev/null
 if [ $? == 0 ];then
  echo " JAVA is installed successfully in user home directory /home/$1 "
 fi
 echo "export JAVA_HOME=/home/$1/jdk-21" >> /home/$1/.bash_profile
 sed -i "/PATH=/s/$/:\/home\/$1\/jdk-21\/bin/" /home/$1/.bash_profile
 if [ $? == 0 ];then
 echo " JAVA_HOME and PATH env. variables are set and JAVA will be available to the user in the next logon"
 fi
fi
