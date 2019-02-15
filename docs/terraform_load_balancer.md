Let us add 2 app servers running Nginx containers in the private subnet 
and configure a load balancer in the public subnet

The app servers are not accessible directly from the internet
and can be accessed via the VPN. Since we haven't configured our VPN yet to
access the instances, we will provide the instances by bootstrapping a cloud-init configuration file
via the user_data resource parameter.

The defacto multi-distribution package cloud-init handles early initialization of a cloud instance.

Create the app.yml cloud config file under the cloud-config directory with the below configuration:

#cloud-config
# Cloud config for application servers

runcmd:
  # Install docker
  - curl -sSL https://get.docker.com/ubuntu/ | sudo sh
  #Run nginx
  - docker run -d -p 80:80 nginx
  

Create the app-servers.tf:
```console
//App servers
resource "aws_instance" "app" {
  count = 2
  ami = "${lookup(var.amis,var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  user_data = ${file(\"cloud-config/app.yml\")}"
  tags = {
    Name = "airpair-example-app-${count.index}"
  }
}

//Load balancer
resource "aws_elb" "app" {
  name = "airpair-example-elb"
  subnets = ["${aws_subnet.public.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  instances ["${aws_instance.app.*.id}"]
}

```

The count parameter indicates the number of identical resources to create. The ${count.index} interpolation in the name tag provides the current index.
You can read more about using count in resources at terraform variable documentation.

Run terraform plan and then terraform apply.



