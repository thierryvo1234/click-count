# Security group for the front

For the front, we are going to build our infrastructure based on this assumption:
- 1 security group allowing incoming HTTP from the Load Balancer to the Web Apps.


Edit security_groups_front.tf:
```console
resource aws_security_group "sg_LB_to_WebApps" {
  name = "sg_LB_to_WebApps"
  description = "allowing incoming HTTP from the Load Balancer to the Web Apps"
  vpc_id = "${aws_vpc.default.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.sg_internet_to_LB.id}"]
  
  }
  tags {
    Name = "clickcount_sg_LB_to_WebApps"
  }
}
```

Also, we will make another assumption:
- 1 security group allowing incoming SSH and ICMP from a specific IP to all instances. As a best protecting pratcice, var.ipv4_local defines only your local address to protect your servers from any undesirable threat connections.

Append security_groups_front.tf:
```console
resource aws_security_group "sg_ssh_and_ping" {
  name = "sg_ssh_and_ping"
  description = "allowing incoming SSH and ICMP from a specific IP to all instances"
  vpc_id = "${aws_vpc.default.id}"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ipv4_local}"]
  }
  
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.ipv4_local}"]
  }
  
  tags {
    Name = "clickcount_sg_ssh_and_ping"
  }
}
```



- The public subnet is accessible and all traffic (0.0.0.0/0) is routed directly to the Internet gateway


Temporarily add the lines in security_groups_front.tf to download/update all required initial packages.
Then when you download all, go to the AWS WEB UI Console and delete it manually. 
It will allow restricting the security on those instances:
```console
resource "aws_security_group" "allow_all" {
  name = "allow all"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}
```


TO TEST:
To allow inter communication inside the same public subnet 
```console
resource "aws_security_group" "allow-inter-communications-inside-public-subnet" {
  name = "inter-local-communication-inside-public-subnet"
  description = "allow inter communications between instances inside the same public subnet"
  vpc_id = "${aws_vpc.default.id}"
  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
#    cidr_blocks = "${var.public_subnet_cidr}"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
```
