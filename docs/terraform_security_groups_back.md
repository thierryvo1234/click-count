# Security group for the back

For the back, we are going to build our infrastructure based on this assumption:

- 1 security group allowing incoming Redis request flow from the Web Apps to Redis Database.
It allows the Web Apps to connect and make requests to the Redis database.

Edit security_groups_back.tf:
```console
resource "aws_security_group" "sg_WebApps_to_Redis_database" {
  name = "sg_WebApps_to_Redis_database"
  description = "allowing incoming Redis request flow from the Web Apps to Redis Database"
  vpc_id = "${aws_vpc.default.id}"
  
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = ["${aws_security_group.sg_LB_to_WebApps.id}"]
  
  }
  tags {
    Name = "clickcount_sg_WebApps_to_Redis_database"
  }
}

```
