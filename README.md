DevOpsPipeline 🚀
Automated Jenkins + VPC Infrastructure Setup for AWS EC2

One-click Terraform scripts to deploy VPC networks and Jenkins CI/CD servers on Ubuntu/CentOS. Includes initial admin password retrieval for instant access.

[![Terraform](https://img.shields.io/badge/Terraform-5C3EE8?style=for-the-badge&logo[Jenkins](https://img.shields.io/badge/Jenkins-D2493E?style=for-the-badge&logo## ✨ Features

✅ One-command Jenkins installation (apt/yum)

🌐 Complete VPC networking with public/private subnets

🔑 Auto-retrieve Jenkins initial admin password

🐳 Docker-ready Jenkins container support

☁️ AWS-optimized for EC2 deployments

📊 Outputs all resource IDs/URLs/IPs

📋 Quick Start
1. Prerequisites
bash
# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
2. Deploy Everything
bash
# Clone & deploy
git clone https://github.com/Dineshyadav3505/DevOpsPipeline
cd DevOpsPipeline

# Configure AWS credentials
export AWS_ACCESS_KEY_ID=your-key
export AWS_SECRET_ACCESS_KEY=your-secret

# Deploy VPC + Jenkins
terraform init
terraform plan
terraform apply -auto-approve
3. Access Jenkins
bash
# Get Jenkins URL & password
terraform output jenkins_url
terraform output jenkins_password

# Or manually retrieve password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Jenkins: http://<EC2-Public-IP>:8080 | Admin Password: From outputs

🗂️ Repository Structure
text
DevOpsPipeline/
├── vpc.tf          # VPC, subnets, security groups
├── variables.tf    # Customizable variables
├── outputs.tf      # Resource outputs
├── version.tf      # Terraform provider versions
├── script/         # Jenkins install scripts
└── README.md       # You're reading it!
🔧 Customization
Edit variables.tf:

text
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "instance_type" { default = "t3.micro" }
variable "region" { default = "ap-south-1" }  # Mumbai for India
🧹 Cleanup
bash
terraform destroy -auto-approve
🚀 Use Cases
CI/CD Master Setup for microservices pipelines

Dev/Test Environments with isolated VPCs

Production Jenkins deployments

Learning/Portfolio projects

📈 Outputs
Resource	Output Name	Example
Jenkins URL	jenkins_url	http://13.232.45.67:8080
Jenkins Password	jenkins_password	a1b2c3d4e5f6...
VPC ID	vpc_id	vpc-0abc123def456
Public IP	instance_public_ip	13.232.45.67
🤝 Contributing
Fork the repo

Create feature branch (git checkout -b feature/add-security-groups)

Commit changes (git commit -m "Add security group rules")

Push & PR
