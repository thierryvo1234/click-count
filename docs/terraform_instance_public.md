# 3 EC2 instances for the front

The public subnet is accessible and all traffic (0.0.0.0/0) is routed directly to the Internet gateway

We will use our security group allowing incoming HTTP from the Load Balancer to the Web Apps.



Edit instance_public.tf :
```console
resource "aws_instance" "instance_public_a" {
  ami = "ami-051707cdba246187b"
  instance_type = "t2.micro"
  availability_zone = "${var.region}a"
  ebs_optimized = true
  subnet_id = "${aws_subnet.public-a.id}"
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}"]
  associate_public_ip_address = true
  
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      timeout = "120s"
      private_key = "${file("/root/.ssh/clickcount-auth")}"
    }

    inline = [
      "sudo yum -y update",
      "sudo yum -y install telnet"
    ]
  }

  
  tags {
    Name = "instance_public_a"
  }
  
  ebs_block_device {
    device_name = "/dev/sda"
    volume_type = "gp2"
    volume_size = "300"
    delete_on_termination = "true"
  }
}

resource "aws_instance" "instance_public_b" {
  ami = "ami-051707cdba246187b"
  instance_type = "t2.micro"
  availability_zone = "${var.region}b"
  ebs_optimized = true
  subnet_id = "${aws_subnet.public-b.id}"
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}"]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      timeout = "120s"
      private_key = "${file("/root/.ssh/clickcount-auth")}"
    }

    inline = [
      "sudo yum -y update",
      "sudo yum -y install telnet"
    ]
  }
  
  tags {
    Name = "instance_public_b"
  }
  
  ebs_block_device {
    device_name = "/dev/sda"
    volume_type = "gp2"
    volume_size = "300"
    delete_on_termination = "true"
  }
}

resource "aws_instance" "instance_public_c" {
  ami = "ami-051707cdba246187b"
  instance_type = "t2.micro"
  availability_zone = "${var.region}c"
  ebs_optimized = true
  subnet_id = "${aws_subnet.public-c.id}"
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}"]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      timeout = "120s"
      private_key = "${file("/root/.ssh/clickcount-auth")}"
    }

    inline = [
      "sudo yum -y update",
      "sudo yum -y install telnet"
    ]
  }
  
  tags {
    Name = "instance_public_c"
  }
  
  ebs_block_device {
    device_name = "/dev/sda"
    volume_type = "gp2"
    volume_size = "300"
    delete_on_termination = "true"
  }
}

```
The "instance a" will be used as our Kubernetes master node.

The "instance b and instance c" will be used as our Kubernetes workers nodes.

Later on, through Ansible, we will add the configurations for those Kubernetes nodes.



Temporarily modify the lines in instance_public.tf to download/update all required initial packages.
Then when it is done, go to the AWS Console UI and delete it manually.

Replace:
```console
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}"]

```
by:
```console
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}", "${aws_security_group.sg_allow_all.id}"]
```

