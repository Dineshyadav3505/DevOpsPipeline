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

resource "aws_route_table" "jenkins_private_route_table" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name        = "jenkins-private-route-table"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}

resource "aws_route_table" "jenkins_public_route_table" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name        = "jenkins-public-route-table"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name        = "jenkins-igw"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}

resource "aws_eip" "jenkins_eip" {
  domain = "vpc"

  tags = {
    Name        = "jenkins-eip"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}

resource "aws_nat_gateway" "jenkins_nat_gateway" {
  allocation_id = aws_eip.jenkins_eip.id
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name        = "jenkins-nat-gateway"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}

resource "aws_security_group" "jenkins_public_instance_sg" {
  name        = "jenkins-security-group-for-public-instances"
  description = "Security group for Jenkins instances"
  vpc_id      = module.vpc.vpc_id

  # Allow ping from public and private instances within VPC
  ingress {
    description = "Allow ICMP from within VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow inbound Jenkins UI access
  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow inbound SSH access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "jenkins-security-group"
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}

resource "aws_instance" "jenkins_public_instance" {

  for_each = {
    "jenkins_master_1" = "t2.micro"
  }

  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = each.value
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins_public_instance_sg.id]

  user_data = file("script/jenkins_master_setup.sh")

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

resource "aws_instance" "jenkins_private_instance" {
  for_each = {
    "jenkins_worker_node_1" = "t2.micro"
    "jenkins_worker_node_2" = "t2.micro"
  }

  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = each.value
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = true
  user_data = file("script/jenkins_worker_setup.sh")

  root_block_device {
    volume_size           = var.environment == "prod" ? 50 : var.instance_size
    volume_type           = "gp3"
    delete_on_termination = true # Deletes volume when instance is terminated
    encrypted             = true # Enable encryption
  }

  vpc_security_group_ids = [aws_security_group.jenkins_private_instance_sg.id]

  tags = {
    Name        = each.key
    Terraform   = "true"
    Environment = var.environment
    Purpose     = "jenkins-pipeline"
  }
}
