terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }
  backend "s3" {
    bucket = "bucketfortesting3"
    key    = "ans/ansdok/tf-state"
    region = "eu-west-3"
  }

}

provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "amazon-linux-latest" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-subnet-1"
  }
}

resource "aws_security_group" "myapp-sg" {
  name   = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Inbound HTTP 8080 ALL"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Inbound HTTP 80 MYIP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description     = "Outbound ALL"
    from_port       = 0    //any
    to_port         = 0    //any
    protocol        = "-1" //all
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.depl_env_prefix}-myapp-sg"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-igw"
  }
}


resource "aws_route_table" "myapp-rtb" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-rtb"
  }
}

# Associate subnet with Route Table
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-rtb.id
}

//ssh key myst be present and created beforehand
resource "aws_key_pair" "myapp-ssh-key" {
  key_name   = "myapp-server-key"
  public_key = file(var.public_key_location) //doesn't use interpolation syntax ${} as there is no string
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.amazon-linux-latest.id
  instance_type               = var.instance_type
  key_name                    = "myapp-server-key"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
  availability_zone           = var.avail_zone
  //user_data_replace_on_change = true //forces instance recreation

  //user_data = file("entry-script.sh") //if no file is used, <<EOF syntax needed

  tags = {
    Name = "${var.depl_env_prefix}-ansdok Server"
  }
}

# The primary use-case for the null resource is as a do-nothing container for
# arbitrary actions taken by a provisioner.
#
# use null_resource to execute arbitrary jobs, within a resource lifecycle
# ansible-playbook --inventory flag takes a file or a list of ips
# e.g. (self.public_ip or aws_instance.myapp-server.public_ip)
#
# triggers:
# A map of arbitrary strings that, when changed, will force the null resource to be replaced, 
# re-running any associated provisioners.

resource "null_resource" "run-playbook-on-server" {
  # Changes to the instance requires re-provisioning
  triggers = {
    trigger_instance_ip_changed = aws_instance.myapp-server.public_ip
  }

  provisioner "local-exec" {
    working_dir = "/home/mltamd/learn/ansible/learn-ansible"
    command     = "ansible-playbook --inventory ${aws_instance.myapp-server.public_ip}, --private-key ${var.ssh_private_key} --user ec2-user deploy-ansdok-newuser.yml"
  }

}

output "data-AMI-id-found" {
  value = data.aws_ami.amazon-linux-latest.id
}

output "instance-myapp-server-public-IP" {
  value = aws_instance.myapp-server.public_ip
}