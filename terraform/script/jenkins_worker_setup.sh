# !/bin/bash

# Install Java 21 JRE on Ubuntu
sudo apt-get update
sudo apt install -y fontconfig openjdk-21-jre 
Java --version

# Install Trivy on Ubuntu
sudo apt-get update
sudo apt-get install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg -dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install -y trivy
sudo snap install trivy

#  Install Docker on Ubuntu
sudo apt-get update
sudo apt-get docker.io -y 
sudo apt-get install docker-compose -y
sudo usermod -aG docker $USER && newgrp docker


# Install SonarQube using Docker
docker run -d -p 9000:9000 --name sonarqube-server sonarqube:lts-community
docker ps

