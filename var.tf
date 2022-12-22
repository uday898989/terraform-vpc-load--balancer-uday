# # Variable
variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  default = "default"
}

# variable "aws_region" {
#   description = "The AWS region to create things in."
#   default     = "us-east-1"
# }

# variable "key_name" {
#   description = " SSH keys to connect to ec2 instance"
#   default     = "Jenkins"
# }

# variable "instance_type" {
#   description = "instance type for ec2"
#   default     = "t2.micro"
# }

# variable "security_group" {
#   description = "Name of security group"
#   default     = "my-jenkins-security-group"
# }

# variable "tag_name" {
#   description = "Tag Name of for Ec2 instance"
#   default     = "my-ec2-instance"
# }

# variable "ami_id" {
#   description = "AMI for Ubuntu Ec2 instance"
#   default     = "ami-08c40ec9ead489470"
# }


variable "counts" {
  default = 1
}
variable "region" {
  description = "AWS region for hosting our your network"
  default     = "us-east-1"
}

variable "key_name" {
  description = "The AWS region to create things in."
  default     = "Jenkins"
}

variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
    us-east-1 = "ami-08c40ec9ead489470"
  }
}



# variable "region" {
#   type    = string
#   default = "us-east-1"
# }
variable "private_ip_address" {
  type    = string
  default = "10.20.20.120"

}
variable "ServerName" {
  type    = string
  default = "app-server2"
}
variable "SecureVariableOne" {
  type      = string
  default   = ""
  sensitive = true
}
