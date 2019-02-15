resource "aws_subnet" "private-a" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr[0]}"
  availability_zone = "${var.region}a"
  tags {
    Name = "clickcount-private-subnet-a"
  }
}
  
resource "aws_subnet" "private-b" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr[1]}"
  availability_zone = "${var.region}b"
  tags {
    Name = "clickcount-private-subnet-b"
  }
}
  
resource "aws_subnet" "private-c" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr[2]}"
  availability_zone = "${var.region}c"
  tags {
    Name = "clickcount-private-subnet-c"
  }
}

resource "aws_elasticache_subnet_group" "sg-elasticache-redis"
{
  name = "sg-elasticache-redis"
  subnet_ids = ["${aws_subnet.private-a.id}","${aws_subnet.private-b.id}","${aws_subnet.private-c.id}"]  
}

