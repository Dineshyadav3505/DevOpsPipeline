# Generate RSA private key for Jenkins
resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS EC2 key pair
resource "aws_key_pair" "terraform_jenkins_key" {
  key_name   = "terraform-jenkins-key"
  public_key = tls_private_key.jenkins_key.public_key_openssh

  lifecycle {
    create_before_destroy = true
  }
}

# Save private key locally (chmod 400 after apply)
resource "local_file" "jenkins_private_key" {
  content         = tls_private_key.jenkins_key.private_key_pem
  filename        = "terraform-jenkins-key.pem"
  file_permission = "0400"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false


  tags = {
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}

# Create public instance security group
resource "aws_security_group" "jenkins_public_instance_sg" {
  name        = "jenkins-security-group-for-public-instances"
  description = "Security group for Jenkins public instances"
  vpc_id      = module.vpc.vpc_id

  # Allow jenkins ports
  ingress {
    description = "Allow jenkins ports"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ping from public and private instances within VPC
  ingress {
    description = "Allow ICMP from within VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow inbound Jenkins JNLP agent access
  ingress {
    description = "Jenkins JNLP agents"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow inbound SSH access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Fixed: array, not string
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Create public instance
resource "aws_instance" "jenkins_public_instance" {

  for_each = {
    "jenkins_master_1" = "t2.medium"
  }

  ami                         = "ami-02b8269d5e85954ef"
  instance_type               = each.value
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = "terraform-jenkins-key"
  monitoring                  = true
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins_public_instance_sg.id]

  user_data                   = file("script/jenkins_master_setup.sh")
  user_data_replace_on_change = true

  root_block_device {
    volume_size           = var.environment == "prod" ? 50 : var.instance_size
    volume_type           = "gp3"
    delete_on_termination = true # Deletes volume when instance is terminated
    encrypted             = true # Enable encryption
  }

  tags = {
    Name        = each.key
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}



# Create private instance security group
resource "aws_security_group" "jenkins_private_instance_sg" {
  name        = "jenkins-security-group-for-private-instances"
  description = "Security group for Jenkins private instances"
  vpc_id      = module.vpc.vpc_id

  # Allow ping from public and private instances within VPC
  ingress {
    description = "Allow ICMP from within VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow inbound SSH access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Fixed: array, not string
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Create private instance
resource "aws_instance" "jenkins_private_instance" {

  for_each = {
    "jenkins_worker_node_1" = "t2.micro"
  }

  key_name               = "terraform-jenkins-key"
  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = each.value
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins_private_instance_sg.id]

  user_data                   = file("script/jenkins_worker_setup.sh")
  user_data_replace_on_change = true

  root_block_device {
    volume_size           = var.environment == "prod" ? 30 : var.instance_size
    volume_type           = "gp3"
    delete_on_termination = true # Deletes volume when instance is terminated
    encrypted             = true # Enable encryption
  }

  tags = {
    Name        = each.key
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}