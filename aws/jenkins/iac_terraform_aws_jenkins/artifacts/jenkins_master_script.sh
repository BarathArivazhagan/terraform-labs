#!/usr/bin/env bash

sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y

sudo yum-config-manager --enable "Red Hat Enterprise Linux Server 7 Extra(RPMs)"

sudo yum install -y ansible wget java-1.8.0-openjdk-devel git docker

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y
sleep 5
sudo groupadd docker
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins
sudo service jenkins start
sudo systemctl start docker



