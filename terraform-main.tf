terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.51.0"
    }
  }
  # backend "s3" {
  #   bucket = "bucketfortesting3"
  #   key    = "ans/ansdok2/tf-state"
  #   region = "eu-west-3"
  # }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon-linux-latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
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

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-igw"
  }
}


# Option 1: Create new aws_route_table, and then aws_route_table_association 

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  # default route, mapping VPC CIDR block to "local", created implicitly and
  # doesn't need/cannot be specified.

  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-route-table"
  }
}

# Associate subnet with Route Table
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}


# # Option 2: Use the aws created default route table, as below (adoption) (advanced resource)

# resource "aws_default_route_table" "myapp-default-rtb" {
#   default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }

#   tags = {
#     Name = "${var.depl_env_prefix}-tf-myapp-default-rtb"
#   }
# }

// Option 1: Create new security group
resource "aws_security_group" "myapp-sg" {
  name        = "${var.depl_env_prefix}-tf-myapp-sg"
  description = "myapp security group"
  vpc_id      = aws_vpc.myapp-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip, var.ec2_ansible_server_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.depl_env_prefix}-security-group"
  }
}


# # Option 2: Use the aws created, default security group (adoption) (advanced resource)
# resource "aws_default_security_group" "myapp-default-sg" {
#   vpc_id = aws_vpc.myapp-vpc.id

#   ingress {
#     description = "Inbound SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.my_ip]
#   }

#   ingress {
#     description = "Inbound HTTP"
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description     = "Outbound ALL"
#     from_port       = 0    //any
#     to_port         = 0    //any
#     protocol        = "-1" //all
#     cidr_blocks     = ["0.0.0.0/0"]
#     prefix_list_ids = []
#   }

#   tags = {
#     Name = "${var.depl_env_prefix}-myapp-use-default-sg"
#   }
# }



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
    working_dir = "/home/ubuntu/learn-ansible/"
    command     = "ansible-playbook --inventory ${aws_instance.myapp-server.public_ip}, --private-key ${var.ssh_private_key} --user ec2-user deploy-ANSER3-ansdok-newuser-2.yml"
  }

}

output "data-AMI-id-found" {
  value = data.aws_ami.amazon-linux-latest.id
}

output "instance-myapp-server-public-IP" {
  value = aws_instance.myapp-server.public_ip
}
