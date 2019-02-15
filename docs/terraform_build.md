# What we plan to build from "Infrastructure as Code"

The build of the infrastructure through Terraform will be done in 5 steps:
- Presets: Variables et Credentials
- Network:
  - VPC (or Virtual Private Cloud): It provides an isolated section of AWS cloud in which you can launch AWS resources in a virtual network that you have defined 
  - Subnet:
    The VPC is split into subnets (or subnetworks) having specific routing:
    - Public subnet for routing instances outside world
    - Internet Gateway in public subnet
    - Private subnet for internal resources
  - AZ (or Availability Zone): AWS is available on several geographical areas (North America, Ireland, Germany, ...). Each geographical areas is split into at least 2 Availability zones (AZ). Then, each Availability zones has one or more datacenters. Spread our resources on multiple AZ allows us a better availability rate of services.
- Firewall: Security Groups, which is a set of rules of opening network flows (opening ssh flow from a particular IP address, opening HTTP from all internet)
- Servers: 
  - ELB in the public subnet to allow to manage the flow load by routing web traffic to specific application servers
  - EC2 of Application servers running docker of glashfish servers
  - EC2 of Redis for database storage. 
- DNS: Route53

# In practice

Our infrastructure will have 3 layers:
- Layer with 1 Load-Balancer
- Layer with 3 web front spread over AZ
- Layer with 3 Redis database for the data persistence

![in practice 3 layers](https://images.ctfassets.net/95wnqgvmhlea/27OOMHHFpaEUssc4GcEamq/3438f8c802e5faba3a5e244a843d1afb/architecture_skynet.png?fm=png)


# Highlight some essential components:

- NAT/VPN server to route outbound traffic from your instances in private network
and provide your workstation secure access to network resources. Instances in the private subnet rely on a Network Address Translation (NAT) server, running on the public subnet for internet connectivity. All instances in the public subnet can transmit inbound and outbound traffic to and from the internet.
- Application servers running nginx docker container in a private subnet
- Load balanvers in the public subnet to manage and route web traffic to app servers
