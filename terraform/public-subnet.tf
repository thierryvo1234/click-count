resource "aws_subnet" "public-a" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr[0]}"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags {
    Name = "clickcount-public-subnet-a"
  }
}
  
resource "aws_subnet" "public-b" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr[1]}"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  tags {
    Name = "clickcount-public-subnet-b"
  }
}
  
resource "aws_subnet" "public-c" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr[2]}"
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true
  tags {
    Name = "clickcount-public-subnet-c"
  }
}
