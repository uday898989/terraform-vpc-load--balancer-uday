# Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}
# Providers
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create a VPC in AWS part of region i.e. Mumbai 
resource "aws_vpc" "cloudbinary_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name       = "cloudbinary_vpc"
    Created_By = "Terraform"
  }
}

# Create a Public-Subnet1 part of cloudbinary_vpc 
resource "aws_subnet" "cloudbinary_public_subnet1" {
  vpc_id                  = aws_vpc.cloudbinary_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name       = "cloudbinary_public_subnet1"
    created_by = "Terraform"
  }
}
resource "aws_subnet" "cloudbinary_public_subnet2" {
  vpc_id                  = aws_vpc.cloudbinary_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name       = "cloudbinary_public_subnet2"
    created_by = "Terraform"
  }
}

resource "aws_subnet" "cloudbinary_private_subnet1" {
  vpc_id            = aws_vpc.cloudbinary_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name       = "cloudbinary_private_subnet1"
    created_by = "Terraform"
  }
}
resource "aws_subnet" "cloudbinary_private_subnet2" {
  vpc_id            = aws_vpc.cloudbinary_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name       = "cloudbinary_private_subnet2"
    created_by = "Terraform"
  }
}

# IGW
resource "aws_internet_gateway" "cloudbinary_igw" {
  vpc_id = aws_vpc.cloudbinary_vpc.id

  tags = {
    Name       = "cloudbinary_igw"
    Created_By = "Terraform"
  }
}

# RTB
resource "aws_route_table" "cloudbinary_rtb_public" {
  vpc_id = aws_vpc.cloudbinary_vpc.id

  tags = {
    Name       = "cloudbinary_rtb_public"
    Created_By = "Teerraform"
  }
}
resource "aws_route_table" "cloudbinary_rtb_private" {
  vpc_id = aws_vpc.cloudbinary_vpc.id

  tags = {
    Name       = "cloudbinary_rtb_private"
    Created_By = "Teerraform"
  }
}

# Create the internet Access 
resource "aws_route" "cloudbinary_rtb_igw" {
  route_table_id         = aws_route_table.cloudbinary_rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloudbinary_igw.id

}

resource "aws_route_table_association" "cloudbinary_subnet_association1" {
  subnet_id      = aws_subnet.cloudbinary_public_subnet1.id
  route_table_id = aws_route_table.cloudbinary_rtb_public.id
}
resource "aws_route_table_association" "cloudbinary_subnet_association2" {
  subnet_id      = aws_subnet.cloudbinary_public_subnet2.id
  route_table_id = aws_route_table.cloudbinary_rtb_public.id
}
resource "aws_route_table_association" "cloudbinary_subnet_association3" {
  subnet_id      = aws_subnet.cloudbinary_private_subnet1.id
  route_table_id = aws_route_table.cloudbinary_rtb_private.id
}
resource "aws_route_table_association" "cloudbinary_subnet_association4" {
  subnet_id      = aws_subnet.cloudbinary_private_subnet2.id
  route_table_id = aws_route_table.cloudbinary_rtb_private.id
}

# Elastic Ipaddress for NAT Gateway
resource "aws_eip" "cloudbinary_eip" {
  vpc = true
}

# Create Nat Gateway 
resource "aws_nat_gateway" "cloudbinary_gw" {
  allocation_id = aws_eip.cloudbinary_eip.id
  subnet_id     = aws_subnet.cloudbinary_public_subnet1.id

  tags = {
    Name      = "Nat Gateway"
    Createdby = "Terraform"
  }
}


# Allow internet access from NAT Gateway to Private Route Table
resource "aws_route" "cloudbinary_rtb_private_gw" {
  route_table_id         = aws_route_table.cloudbinary_rtb_private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.cloudbinary_gw.id
}

# Network Access Control List 
resource "aws_network_acl" "cloudbinary_nsg" {
  vpc_id = aws_vpc.cloudbinary_vpc.id
  subnet_ids = [
    "${aws_subnet.cloudbinary_public_subnet1.id}",
    "${aws_subnet.cloudbinary_public_subnet2.id}",
    "${aws_subnet.cloudbinary_private_subnet1.id}",
    "${aws_subnet.cloudbinary_private_subnet2.id}"
  ]

  # All ingress port 22 
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  # Allow ingress of port 80
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  # Allow ingress of port 8080
  ingress {
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }
  # Allow ingress of port 8081
  ingress {
    protocol   = "tcp"
    rule_no    = 420
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8081
    to_port    = 8081
  }
  # Allow ingress of port 8082
  ingress {
    protocol   = "tcp"
    rule_no    = 430
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8082
    to_port    = 8082
  }
  # Allow ingress of port 9000
  ingress {
    protocol   = "tcp"
    rule_no    = 440
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 9000
    to_port    = 9000
  }
  # Allow ingress of port 80
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }
  # Allow ingress of ports from 1024 to 65535
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  # Allow egress of port 22
  egress {
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }
  # Allow egress of port 22
  egress {
    protocol   = "tcp"
    rule_no    = 420
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8081
    to_port    = 8081
  }
  # Allow egress of port 22
  egress {
    protocol   = "tcp"
    rule_no    = 430
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8082
    to_port    = 8082
  }
  # Allow egress of port 22
  egress {
    protocol   = "tcp"
    rule_no    = 440
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 9000
    to_port    = 9000
  }
  # Allow egress of port 22
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  # Allow egress of port 80
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  # Allow egress of port 80
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }
  # Allow egress of ports from 1024 to 65535
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name      = "cloudbinary_nsg"
    createdby = "Terraform"
  }
}

# EC2 instance Security group
resource "aws_security_group" "cloudbinary_sg" {
  vpc_id      = aws_vpc.cloudbinary_vpc.id
  name        = "sg_cloudbinary_ssh"
  description = "To Allow SSH From IPV4 Devices"

  # Allow Ingress / inbound Of port 22 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  # Allow Ingress / inbound Of port 80 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  # Allow Ingress / inbound Of port 80 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }
  # Allow Ingress / inbound Of port 80 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
  }
  # Allow Ingress / inbound Of port 80 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
  }
  # Allow Ingress / inbound Of port 80 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
  }
  # Allow Ingress / inbound Of port 8080 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
  }
  # Allow egress / outbound of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cloudbinary_sg"
    Description = "cloudbinary allow SSH - HTTP and Jenkins"
    createdby   = "terraform"
  }

}

data "template_file" "cb_web1_userdata" {
  template = file("${path.module}/install-web1.tpl")

  vars = {
    env = "dev"
  }
}

resource "aws_instance" "cb_web1" {
  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.medium"
  key_name               = "pro"
  subnet_id              = aws_subnet.cloudbinary_private_subnet1.id
  vpc_security_group_ids = [aws_security_group.cloudbinary_sg.id]
  user_data              = data.template_file.cb_web1_userdata.rendered
  iam_instance_profile   = aws_iam_instance_profile.cloudbinary_profile.name

  tags = {
    Name      = "cb_web1"
    CreatedBy = "Terraform"
  }
}

data "template_file" "jumpbox_userdata" {
  template = file("${path.module}/install-jumpbox.tpl")

  vars = {
    env = "dev"
  }
}

resource "aws_instance" "jumpbox" {
  ami                    = "ami-0be29bafdaad782db"
  instance_type          = "t2.medium"
  key_name               = "pro"
  subnet_id              = aws_subnet" "cloudbinary_public_subnet1.id
  vpc_security_group_ids = [aws_security_group.cloudbinary_sg.id]
  user_data              = data.template_file.jumpbox_userdata.rendered
  iam_instance_profile   = aws_iam_instance_profile.cloudbinary_profile.name

  tags = {
    Name      = "jumpbox"
    CreatedBy = "Terraform"
  }
}
data "template_file" "cb_web2_userdata" {
  template = file("${path.module}/install-web2.tpl")

  vars = {
    env = "dev"
  }
}

resource "aws_instance" "cb_web2" {
  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.medium"
  key_name               = "pro"
  subnet_id              = aws_subnet.cloudbinary_private_subnet2.id
  vpc_security_group_ids = [aws_security_group.cloudbinary_sg.id]
  user_data              = data.template_file.cb_web2_userdata.rendered
  iam_instance_profile   = aws_iam_instance_profile.cloudbinary_profile.name

  tags = {
    Name      = "cb_web2"
    CreatedBy = "Terraform"
  }
}


resource "aws_iam_instance_profile" "cloudbinary_profile" {
  role = aws_iam_role.cb_role.name
}

resource "aws_iam_role" "cb_role" {
  name = "cb_ec2_ssm"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": ["ec2.amazonaws.com", "ssm.amazonaws.com"]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cb_ec2_ssm_policy_attachment" {
  role       = aws_iam_role.cb_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}


# Application Load Balancer
resource "aws_lb" "cbalb" {
  name               = "cb-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cloudbinary_sg_lb.id]
  subnets            = [aws_subnet.cloudbinary_public_subnet1.id, aws_subnet.cloudbinary_public_subnet2.id]

  enable_deletion_protection = true
  /* 
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  } */

  tags = {
    Environment = "dev"
  }
}


# EC2 instance Security group
resource "aws_security_group" "cloudbinary_sg_lb" {
  vpc_id      = aws_vpc.cloudbinary_vpc.id
  name        = "sg_lb"
  description = "To Allow SSH From IPV4 Devices"

  # Allow Ingress / inbound Of port 80 
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  # Allow Ingress / inbound Of port 443
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  # Allow egress / outbound of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cloudbinary_sg"
    Description = "cloudbinary allow SSH - HTTP and Jenkins"
    createdby   = "terraform"
  }

}


# Instance Target Group
resource "aws_lb_target_group" "cloudbinary_tg1" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudbinary_vpc.id

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
  }
}

resource "aws_lb_listener" "cb_http_alb_listener" {
  load_balancer_arn = aws_lb.cbalb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.cloudbinary_tg1.arn
    type             = "forward"
  }
}
resource "aws_lb_target_group_attachment" "cb_instance_alb" {
  target_group_arn = aws_lb_target_group.cloudbinary_tg1.arn
  target_id        = element(aws_instance.cb_web1.*.id, count.index)
  port             = 80
  count            = "1"
}
resource "aws_lb_target_group_attachment" "cb_instance_alb_2" {
  target_group_arn = aws_lb_target_group.cloudbinary_tg1.arn
  target_id        = element(aws_instance.cb_web2.*.id, count.index)
  port             = 80
  count            = "1"
}
