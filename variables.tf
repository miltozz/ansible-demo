variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.0.1.0/24"    
}

variable "avail_zone" {
  description = "az for subnet"
  type        = string
  default     = "eu-central-1a"     
}

variable "depl_env_prefix" {
  description = "Deployment environment prefix"
  type        = string
  default     = "dev"     
}

variable "my_ip" {
  description = "My IP for SG SSH ingress"
  type        = string
  default     = "87.202.58.227/32"      
}

variable "ec2_ansible_server_ip" {
  description = "SG SSH ingress for Ansible Server on an EC2 Instance, which runs the playbooks"
  type        = string
  default     = "15.188.50.237/32"      
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"     
}

variable "public_key_location" {
  description = "EC2 instance type"
  type        = string
  default     = "C:\\Users\\MLT\\.ssh\\id_ed25519.pub"     
}

#####################################################################

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
  ]
}