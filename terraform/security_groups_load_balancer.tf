resource "aws_security_group"  "sg_internet_to_LB"  {
  description = "allowing incoming HTTPS from Internet to the Load Balancer"
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "clickcount_sg_internet_to_LB"
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
