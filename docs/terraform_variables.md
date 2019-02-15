# Variables for your Infrastructure

The infrastructure managed by Terraform is defined in .tf files, which are written in HashiCorp Configuration Language (HCL). 

The variables.tf file contains environment specific configuration like region name, CIDR blocks, and AWS credentials.
It defines all the variables that tune your infrastructure.

Edit the variables.tf:
```console
variable "aws_access_key" {
  description = "AWS access key"
  default = "xxxxxxxxxxx"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default = "xxxxxxxxxxx"
}

variable "public_key_path"  {
  description = "The path of the public SSH key"
  default = "/root/.ssh/clickcount-auth.pub"
}

variable "ipv4_local"  {
  description = "ipv4 address of the local machine"
  default = "217.163.58.239/32"
}


variable "region"  {
  description = "AWS region to host your network"
  default = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default = "10.123.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default = ["10.123.0.0/24","10.123.1.0/24","10.123.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default = ["10.123.10.0/24","10.123.11.0/24","10.123.12.0/24"]
}
```

Below, you must replace the default ("xxxxxxxxxxx") aws_access_key and aws_secret_key with the generated ones provided when you created the IAM user.



