# The private subnet for the back

Since we want to create a Redis database cluster in the back-end:
- we will add 3 back subnets for providing the resilience, the self-healing, ...
- we will add the aws_elasticache_subnet_group to be referenced later on the aws_elasticache_replication_group module


Here are our 3 back subnets of IP ranges:
- 10.128.10.0/24 
- 10.128.11.0/24 
- 10.128.12.0/24 

Each subnet will be in 1 distinct availability zone (AZ).


Let us edit private-subnet.tf:
```console
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
```

