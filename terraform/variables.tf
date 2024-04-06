####################################

variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

############ networking ############

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

########### load balancer ###########

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/"
}

variable "amis" {
  description = "AMI ID"
 default = {
    us-east-1 = "ami-0cd59ecaf368e5ccf"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_instance_name" {
  description = "Name of the EC2 instance"
  default     = "terraform-lab"
}

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/aws/aws_key.pub"
}

########### auto-scaling ############

# auto scaling

variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "2"
}

variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "2"
}

variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "2"
}

variable "key_name" {
  type        = string
  description = "Key name"
  default     = "prod-key"     
}
