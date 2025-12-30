#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install Java 21 (OpenJDK) - works on Ubuntu 20.04/22.04/24.04
apt-get update -y
apt-get install -y fontconfig openjdk-21-jre-headless

# Verify installation
java --version
echo "Java 21 installed successfully"

# Install Jenkins
wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins

# Start and enable Jenkins
systemctl start jenkins
systemctl enable jenkins
echo "Jenkins installed and started successfully"

# Install Docker and add user to docker group 
sudo apt-get update
sudo apt-get docker.io -y 
sudo apt-get install docker-compose -y
sudo usermod -aG docker $USER && newgrp docker 

# Install SonarQube
docker run -itd --name SonarQube-Server -p 9000:9000 sonarqube:lts-community

# Install Helm Chart
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Add stable repository
helm repo add stable https://charts.helm.sh/stable

# Create Prometheus Namespace
kubectl create namespace prometheus
kubectl get ns


# Install Prometheus using Helm
helm install stable prometheus-community/kube-prometheus-stack -n prometheus

# Verify prometheus installation
kubectl get pods -n prometheus

# Check the services file (svc) of the Prometheus
kubectl get svc -n prometheus

# Expose Prometheus and Grafana to the external world through Node Port
kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus\ 

# Verify service
kubectl get svc -n prometheus

# Now,let’s change the SVC file of the Grafana and expose it to the outer world
kubectl edit svc stable-grafana -n prometheus

# Check grafana service
kubectl get svc -n prometheus

