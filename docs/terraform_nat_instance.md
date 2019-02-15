# Create the NAT Instance

NAT instances reside in the public subnet.
In order to route traffic, they need to have the 'source destination check' parameter disabled.
They belong to the default and nat security groups. The default security group allows traffic from any instance within the group.
The nat security group allows SSH and VPN traffic from the internet

Edit nat-server.tf:
```console
resource "aws_instance" "nat"  {
  ami = "$(lookup(var.amis, var.region))"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.id}"
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  tags = {
    Name = "nat"
  }
  connection {
    user="ubuntu"
    key_file = "ssh/insecure-deployer"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
      "echo 1 | sudo tee /proc/sys/net/ipv4/conf.all forwarding > /dev/null",
      /* Install docker */
      "curl -sSL https://get.docker .com/ubuntu/ | sudo sh",
      /* Initialiaze open vpn data container */
      "sudo mkdir -p /etc/openvpn",
      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      /* Generate OpenVPN server config */
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p $(var.vpc_cidr) -u udp://$(aws_instance.nat.public_ip)"
    ]
  }
}

```

In order for the NAT instance to route traffic, iptables needs to be configured with a rule in the nat table for IP Masquerade. We also need to install Docker, download the OpenVPN container and generate server configuration.



