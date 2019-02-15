# Terraform 

Terraform is an infrastructure automation tool created by Hashicorp. 
It is a tool used for building, changing, versioning and destroying infrastructure and its resources such as compute instances, storage, networking, load balancers DNS etc.

It defines your infrastructure as code and it is cloud-agnostic. Terraform allows you to define the infrastructure for as simple as a server to a complete data center through configuration scripts written in HCL, from which it creates an execution plan depicting what it will do to achieve the desired state, and afterwards executes it to construct the create it, modified or destroyed to reach the desired state of the infrastructure. 

# Our case with AWS

Here, Terraform provisions a full AWS infrastructure from the ground using Terraform. 

In our case, we are going to create a production-ready environment in AWS using Terraform automation which will require us to set up a VPC, Network Gateway, subnets, routes, security groups, EC2 machines with Redis installed inside the private network, and the web app in the public subnet.


## Setup

You can install terraform using Homebrew on a Mac. Then verify, terraform is well installed.
```console
brew update && brew install terraform.


terraform

    usage: terraform [--version] [--help] <command> [<args>]

    Available commands are:
        apply      Builds or changes infrastructure
        destroy    Destroy Terraform-managed infrastructure
        get        Download and install modules for the configuration
        graph      Create a visual graph of Terraform resources
        init       Initializes Terraform configuration from a module
        output     Read an output from a state file
        plan       Generate and show an execution plan
        pull       Refreshes the local state copy from the remote server
        push       Uploads the the local state to the remote server
        refresh    Update local state file against real resources
        remote     Configures remote state management
        show       Inspect Terraform state or plan
        version    Prints the Terraform version
```

# Example when typing "terraform plan" for some other project
Running a terraform plan will generate an execution plan for you to verify before creating the actual resources. It is recommended that you always inspect the plan before running the "terraform apply" command.

Launch:
```console
terraform plan
```

OUTPUT:
```console
Refreshing Terraform state prior to plan...

aws_vpc.default: Refreshing state... (ID: vpc-30965455)

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ aws_internet_gateway.default
    vpc_id: "" => "vpc-30965455"

+ aws_route_table.public
    route.#:                       "" => "1"
    route.~1235774185.cidr_block:  "" => "0.0.0.0/0"
    route.~1235774185.gateway_id:  "" => "${aws_internet_gateway.default.id}"
    route.~1235774185.instance_id: "" => ""
    vpc_id:                        "" => "vpc-30965455"

+ aws_route_table_association.public
    route_table_id: "" => "${aws_route_table.public.id}"
    subnet_id:      "" => "${aws_subnet.public.id}"

+ aws_subnet.public
    availability_zone:       "" => "us-west-1a"
    cidr_block:              "" => "10.128.0.0/24"
    map_public_ip_on_launch: "" => "1"
    tags.#:                  "" => "1"
    tags.Name:               "" => "public"
    vpc_id:                  "" => "vpc-30965455"
```

The "+" ahead of aws_internet_gateway.default indicates that a new resource will be created.

After reviewing your plan, run "terraform apply" to create the resources. Finally, you can verify that the subnet has been created by running "terraform show" or by visiting the AWS console.



