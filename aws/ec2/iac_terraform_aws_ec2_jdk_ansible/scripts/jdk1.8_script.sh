sudo yum install java-1.8.0-openjdk-devel -y
sudo alternatives --install /usr/bin/java java /usr/lib/jvm/java-1.8.0-openjdk/bin 3
sudo alternatives --config java <<< '3'