# Authentification by AWS SSH Key Pair

To log in directly to the newly created instances, we can use the SSH key pair method.

Let us generate the new ssh key pair:
```console
keyname=clickcount-auth
keymail="thierry.vo@devoteam.com"
ssh-keygen -t rsa -b 4096 -f $keyname -C $keymail
```

Edit key-pairs.tf:

```console
resource "aws_key_pair" "auth"  {
  key_name = "clickcount-auth"
  public_key = "${file(var.public_key_path)}"
}
```

Then when the instances are all created 
by the command "Terraform apply", you can ssh to them.
For example, if I want to ssh to the server ec2-35-180-202-55.eu-west-3.compute.amazonaws.com:
```console
ssh ec2-user@ec2-35-180-202-55.eu-west-3.compute.amazonaws.com -i /root/.ssh/clickcount-auth
```
