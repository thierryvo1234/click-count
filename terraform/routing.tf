resource "aws_internet_gateway" "gw-to-internet" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "route-to-gw" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw-to-internet.id}" 
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.route-to-gw.id}"
}

resource "aws_route_table_association" "public-b" {
  subnet_id = "${aws_subnet.public-b.id}"
  route_table_id = "${aws_route_table.route-to-gw.id}"
}

resource "aws_route_table_association" "public-c" {
  subnet_id = "${aws_subnet.public-c.id}"
  route_table_id = "${aws_route_table.route-to-gw.id}"
}
