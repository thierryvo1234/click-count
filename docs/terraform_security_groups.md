# Security groups

We are going to create :
- 1 security group allowing incoming HTTPS from Internet to the Load Balancer
- 1 security group allowing incoming HTTP from the Load Balancer to the Web Apps
- 1 security group allowing incoming Redis flow from the Web Apps. It allows the Web Apps to connect and make requests to the 
Redis database.
- 1 security group allowing incoming SSH and ICMP from a specific IP to all instances

Note: Terraform only allows the definition of ingress rules. The egress rules are not managed yet.

# How to configure
- The private subnet is inaccessible to the internet (both in and out)
- The public subnet is accessible and all traffic (0.0.0.0/0) is routed directly to the Internet gateway
