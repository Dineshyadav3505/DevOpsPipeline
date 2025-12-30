#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install Java 21 (OpenJDK) - works on Ubuntu 20.04/22.04/24.04
apt-get update -y
apt-get install -y fontconfig openjdk-21-jre-headless


# Install Docker and add user to docker group
sudo apt-get update
sudo apt-get docker.io -y 
sudo apt-get install docker-compose -y
sudo usermod -aG docker $USER && newgrp docker 

# Install Trivy
sudo apt-get update
sudo apt-get install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg -dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install -y trivy
sudo snap install trivy

