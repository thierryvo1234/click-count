resource "aws_instance" "instance_public_a" {
  ami = "ami-051707cdba246187b"
  instance_type = "t3.medium"
  availability_zone = "${var.region}a"
  subnet_id = "${aws_subnet.public-a.id}"
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}","${aws_security_group.allow_all.id}","${aws_security_group.allow-inter-communications-inside-public-subnet.id}"]

  associate_public_ip_address = true
  key_name = "clickcount-auth"
  
  tags {
    Name = "instance_public_a"
  }
  

    provisioner "remote-exec" {
      connection {
        type = "ssh"
        user = "ec2-user"
        timeout = "1200s"
        private_key = "${file("/root/.ssh/clickcount-auth")}"
      }

      inline = [
        "sudo yum -y update"
      ]
    }
}

resource "aws_instance" "instance_public_b" {
  ami = "ami-051707cdba246187b"
  instance_type = "t3.medium"
  availability_zone = "${var.region}b"
  subnet_id = "${aws_subnet.public-b.id}"
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}","${aws_security_group.allow_all.id}","${aws_security_group.allow-inter-communications-inside-public-subnet.id}"]


  associate_public_ip_address = true
  key_name = "clickcount-auth"

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "ec2-user"
        timeout = "1200s"
        private_key = "${file("/root/.ssh/clickcount-auth")}"
    }

    inline = [
      "sudo yum -y update",
    ]
  }

  tags {
    Name = "instance_public_b"
  }
 
}

resource "aws_instance" "instance_public_c" {
  ami = "ami-051707cdba246187b"
  instance_type = "t3.medium"
  availability_zone = "${var.region}c"
  subnet_id = "${aws_subnet.public-c.id}"
  security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}", "${aws_security_group.sg_ssh_and_ping.id}","${aws_security_group.allow_all.id}","${aws_security_group.allow-inter-communications-inside-public-subnet.id}"]

  associate_public_ip_address = true
  key_name = "clickcount-auth"

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      timeout = "1200s"
      private_key = "${file("/root/.ssh/clickcount-auth")}"
    }

    inline = [
      "sudo yum -y update",
    ]
  }

  tags {
    Name = "instance_public_c"
  }  
}

