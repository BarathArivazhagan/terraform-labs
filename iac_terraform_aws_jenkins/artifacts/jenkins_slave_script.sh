#!/usr/bin/env bash

sudo yum-config-manager --enable "Red Hat Enterprise Linux Server 7 Extra(RPMs)"
sudo yum install -y wget java-1.8.0-openjdk-devel git docker
sudo systemctl start docker



