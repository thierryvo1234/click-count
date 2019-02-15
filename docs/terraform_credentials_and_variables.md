# Credentials and Variables

Terraform is going to create the environment on AWS
- based on main.tf  # where all actions happens
- based on variables.tf  # is pulled by main.tf. It will have empty variables
- based on terraform.tfvars  # is pulled by variables.tf. Remenber to put terraform.tfvars in .gitignore to keep all secrets safe
- userdata which is going to be consumed by autoscaling group
- and populate the aws_hosts with the IP address of dev instances and the names of the S3 buckets, which then ansible is going
to be used to deploy wordpress.yml, which will deploy wordpress on the dev
and s3update.yml which allows dev instances to send the code to the S3 bucket.


Edit main.tf:
```console
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}
```

Edit variables.tf:
```console
variable "aws_region" {}
variable "aws_profile" {}
```

Edit terraform.tfvars:
```console
aws_profile = "profile_terransible"
aws_region = "eu-west-3"
```

Check everything is ok with:
```console
terraform init
    Initializing provider plugins...

    The following providers do not have any version constraints in configuration,
    so the latest version was installed.

    To prevent automatic upgrades to new major versions that may contain breaking
    changes, it is recommended to add version = "..." constraints to the
    corresponding provider blocks in configuration, with the constraint strings
    suggested below.

    * provider.aws: version = "~> 1.51"

    Terraform has been successfully initialized!
    
terraform plan

```

Edit main.tf:
```console
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}



#------- IAM --------

#s3_access

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = "${aws_iam_role.s3_access_role.name}"
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_access_role.id}"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:assumeRole",
      "Principal": {
        "Service": "ec2.amazon.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
```

To apply the change:
```console
terraform init
terraform plan
```





 
