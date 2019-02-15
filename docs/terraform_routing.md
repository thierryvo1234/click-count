# Route table for routing and Internet gateway for internet

Let us edit routing.tf:
```console
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


```


# When we go on the AWS Web UI Console,

and check the new route table "route-to-gw":

### Under the Routes tab, we get:
```console
Destination           Target                    Status      Propagated
10.123.0.0/16         local                     active      No	
0.0.0.0/0             igw-0a16112bf05f1795c     active      No
```
shows us that:
- if the IP target is in the IP range 10.123.0.0/16, so it will be routed to the local (corresponding to the IP range of VPC), 
- otherwise, it will be forward to the internet gateway


### Under Subnet associations tab, we get:
```console
Subnet ID                                                 IPv4 CIDR         IPv6 CIDR
subnet-087ae93f59621ee06 | clickcount-public-subnet-b     10.123.1.0/24     -
subnet-01969ad91ff8bb397 | clickcount-public-subnet-c     10.123.2.0/24     -
subnet-049f1386b41459f9e | clickcount-public-subnet-a     10.123.0.0/24     -


The following subnets have not been explicitly associated with any route tables
and are therefore associated with the main route table:

Subnet ID                                                 IPv4 CIDR         IPv6 CIDR
subnet-04f95aa7f60498180 | clickcount-private-subnet-c    10.123.12.0/24    -
subnet-09c9101ac3986ca06 | clickcount-private-subnet-b    10.123.11.0/24    -
subnet-00de0868d676a360d | clickcount-private-subnet-a    10.123.10.0/24    -

```


