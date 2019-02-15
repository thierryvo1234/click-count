variable "aws_access_key" {
  description = "AWS access key"
  default = "AKIAIFIJBQZblablabla"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default = "OLNT0/HW0Xh+g3wDZ4vN+iGaDD/kNe4blablabla"
}

variable "public_key_path"  {
  description = "The path of the public SSH key"
  default = "/root/.ssh/clickcount-auth.pub"
}

variable "ipv4_local"  {
  description = "ipv4 address of the local machine"
#  default = "176.152.98.0/24"
  default = "0.0.0.0/0"

}

variable "region" {
  description = "AWS region to host your network"
  default = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default = "10.123.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default = ["10.123.0.0/24", "10.123.1.0/24", "10.123.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default = ["10.123.10.0/24","10.123.11.0/24","10.123.12.0/24"]
}
