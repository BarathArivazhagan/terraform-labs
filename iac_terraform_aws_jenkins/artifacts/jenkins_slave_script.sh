#!/usr/bin/env bash

sudo yum-config-manager --enable "Red Hat Enterprise Linux Server 7 Extra(RPMs)"
sudo yum install -y wget java-1.8.0-openjdk-devel git docker
sudo groupadd docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker



