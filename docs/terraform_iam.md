


# 1. Local Setup 

On your local machine, install:
- terraform 
- ansible
- AWS client to communicate with AWS cloud
and the AWS client to connect to AWS
```console
python --version   # version 2.7 at least
yum update
yum install python-pip

curl -O https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
mkdir /opt/terraform
unzip terraform_0.11.10_linux_amd64.zip -d /opt/terraform
PATH=$PATH:/opt/terraform
terraform --version

yum install ansible
ansible --version

pip install awscli
aws --version
```


# 2. On AWS, setup credential IAM

IAM is an AWS feature, that can only be configured through the AWS Web UI. IAM is going to give in our case, to terraform, the permission access to provision resources. 

On AWS Web UI:
- Go to IAM console / Users / Add user 
- => Fill User name = terransible, Access type = Programmatic access
- => Click on Next permissions / Attach existing policies directly => Check AdministratorAccess to attach the AdministratorAccess policy
- => Click on Next review / Create User
- => Download the credential .csv file # make sure to download the credential

Thanks the credential .csv file,
we can retrieve the information on "AWS Access Key Id" and "AWS Secret Access Key"
that we can give to Terraform settings on our local machine.

In our case, we are going to create a new profile named "profile_terransible"

```console
aws configure --profile terransible

    AWS Access Key Id: xxxxx # Fill with the AWS Access Key Id provided by credential .csv file,
    AWS Secret Access Key: xxxxx  # Fill with the AWS Secret Access Key provided by credential .csv file,
    Default region name: eu-west-3  # for Paris Region, France
```

To check that the client can now communicate with the AWS cloud, let us run this command
```console
aws ec2 describe-instances --profile terransible
```

OUTPUT:
```console
{
    "Reservations": [
        {
            "Instances": [
                {
                    "Monitoring": {
                        "State": "disabled"
                    }, 
                    "PublicDnsName": "", 
                    "StateReason": {
                        "Message": "Client.UserInitiatedShutdown: User initiated shutdown", 
                        "Code": "Client.UserInitiatedShutdown"
                    }, 
                    "State": {
                        "Code": 80, 
                        "Name": "stopped"
                    }, 
                    "EbsOptimized": false, 
                    "LaunchTime": "2018-06-26T06:30:26.000Z", 
                    "PrivateIpAddress": "172.31.32.87", 
                    "ProductCodes": [], 
                    "VpcId": "vpc-a7dfb7ce", 
                    "StateTransitionReason": "User initiated (2018-06-26 07:19:42 GMT)", 
                    "InstanceId": "i-0cf00149b1602ae8a", 
                    "EnaSupport": true, 
                    "ImageId": "ami-969c2deb", 
                    "PrivateDnsName": "ip-172-31-32-87.eu-west-3.compute.internal", 
                    "KeyName": "2018 June 2 AWS keyPair", 
                    "SecurityGroups": [
                        {
                            "GroupName": "WebDMZ", 
                            "GroupId": "sg-891fe4e1"
                        }
                    ], 
                    "ClientToken": "", 
                    "SubnetId": "subnet-aa1cdce7", 
                    "InstanceType": "t2.nano", 
                    "NetworkInterfaces": [
                        {
                            "Status": "in-use", 
                            "MacAddress": "0e:eb:f9:3c:df:a8", 
                            "SourceDestCheck": true, 
                            "VpcId": "vpc-a7dfb7ce", 
                            "Description": "", 
                            "NetworkInterfaceId": "eni-3517b11e", 
                            "PrivateIpAddresses": [
                                {
                                    "PrivateDnsName": "ip-172-31-32-87.eu-west-3.compute.internal", 
                                    "Primary": true, 
                                    "PrivateIpAddress": "172.31.32.87"
                                }
                            ], 
                            "PrivateDnsName": "ip-172-31-32-87.eu-west-3.compute.internal", 
                            "Attachment": {
                                "Status": "attached", 
                                "DeviceIndex": 0, 
                                "DeleteOnTermination": true, 
                                "AttachmentId": "eni-attach-940804f7", 
                                "AttachTime": "2018-06-26T06:30:26.000Z"
                            }, 
                            "Groups": [
                                {
                                    "GroupName": "WebDMZ", 
                                    "GroupId": "sg-891fe4e1"
                                }
                            ], 
                            "Ipv6Addresses": [], 
                            "OwnerId": "412508216422", 
                            "SubnetId": "subnet-aa1cdce7", 
                            "PrivateIpAddress": "172.31.32.87"
                        }
                    ], 
                    "SourceDestCheck": true, 
                    "Placement": {
                        "Tenancy": "default", 
                        "GroupName": "", 
                        "AvailabilityZone": "eu-west-3c"
                    }, 
                    "Hypervisor": "xen", 
                    "BlockDeviceMappings": [], 
                    "Architecture": "x86_64", 
                    "RootDeviceType": "ebs", 
                    "IamInstanceProfile": {
                        "Id": "AIPAIZPZYDYHVSCK6H32O", 
                        "Arn": "arn:aws:iam::412508216422:instance-profile/AllowsEC2ToCallDynamoDB"
                    }, 
                    "RootDeviceName": "/dev/xvda", 
                    "VirtualizationType": "hvm", 
                    "AmiLaunchIndex": 0
                }
            ], 
            "ReservationId": "r-0f0b1fc8d9a37dae4", 
            "Groups": [], 
            "OwnerId": "412508216422"
        }, 
        {
            "Instances": [
                {
                    "Monitoring": {
                        "State": "enabled"
                    }, 
                    "PublicDnsName": "ec2-52-47-52-153.eu-west-3.compute.amazonaws.com", 
                    "StateReason": {
                        "Message": "Client.UserInitiatedShutdown: User initiated shutdown", 
                        "Code": "Client.UserInitiatedShutdown"
                    }, 
                    "State": {
                        "Code": 80, 
                        "Name": "stopped"
                    }, 
                    "EbsOptimized": false, 
                    "LaunchTime": "2018-06-17T15:49:45.000Z", 
                    "PublicIpAddress": "52.47.52.153", 
                    "PrivateIpAddress": "172.31.37.59", 
                    "ProductCodes": [], 
                    "VpcId": "vpc-a7dfb7ce", 
                    "StateTransitionReason": "User initiated (2018-06-17 17:05:39 GMT)", 
                    "InstanceId": "i-0812ec1235e4bfc54", 
                    "EnaSupport": true, 
                    "ImageId": "ami-969c2deb", 
                    "PrivateDnsName": "ip-172-31-37-59.eu-west-3.compute.internal", 
                    "KeyName": "2018 June 2 AWS keyPair", 
                    "SecurityGroups": [
                        {
                            "GroupName": "Security group 2018 June 2 ", 
                            "GroupId": "sg-cb4dafa3"
                        }
                    ], 
                    "ClientToken": "", 
                    "SubnetId": "subnet-aa1cdce7", 
                    "InstanceType": "t2.micro", 
                    "NetworkInterfaces": [
                        {
                            "Status": "in-use", 
                            "MacAddress": "0e:df:1e:18:d6:9e", 
                            "SourceDestCheck": true, 
                            "VpcId": "vpc-a7dfb7ce", 
                            "Description": "", 
                            "NetworkInterfaceId": "eni-b0bd6c9b", 
                            "PrivateIpAddresses": [
                                {
                                    "PrivateDnsName": "ip-172-31-37-59.eu-west-3.compute.internal", 
                                    "PrivateIpAddress": "172.31.37.59", 
                                    "Primary": true, 
                                    "Association": {
                                        "PublicIp": "52.47.52.153", 
                                        "PublicDnsName": "ec2-52-47-52-153.eu-west-3.compute.amazonaws.com", 
                                        "IpOwnerId": "412508216422"
                                    }
                                }
                            ], 
                            "PrivateDnsName": "ip-172-31-37-59.eu-west-3.compute.internal", 
                            "Attachment": {
                                "Status": "attached", 
                                "DeviceIndex": 0, 
                                "DeleteOnTermination": true, 
                                "AttachmentId": "eni-attach-c1b984a2", 
                                "AttachTime": "2018-06-02T18:51:28.000Z"
                            }, 
                            "Groups": [
                                {
                                    "GroupName": "Security group 2018 June 2 ", 
                                    "GroupId": "sg-cb4dafa3"
                                }
                            ], 
                            "Ipv6Addresses": [], 
                            "OwnerId": "412508216422", 
                            "PrivateIpAddress": "172.31.37.59", 
                            "SubnetId": "subnet-aa1cdce7", 
                            "Association": {
                                "PublicIp": "52.47.52.153", 
                                "PublicDnsName": "ec2-52-47-52-153.eu-west-3.compute.amazonaws.com", 
                                "IpOwnerId": "412508216422"
                            }
                        }
                    ], 
                    "SourceDestCheck": true, 
                    "Placement": {
                        "Tenancy": "default", 
                        "GroupName": "", 
                        "AvailabilityZone": "eu-west-3c"
                    }, 
                    "Hypervisor": "xen", 
                    "BlockDeviceMappings": [], 
                    "Architecture": "x86_64", 
                    "RootDeviceType": "ebs", 
                    "IamInstanceProfile": {
                        "Id": "AIPAINTMCRGAIJ2X6GJS2", 
                        "Arn": "arn:aws:iam::412508216422:instance-profile/S3-Admin-Access"
                    }, 
                    "RootDeviceName": "/dev/xvda", 
                    "VirtualizationType": "hvm", 
                    "Tags": [
                        {
                            "Value": "Server for Django 2018 June 2", 
                            "Key": "Goal"
                        }
                    ], 
                    "AmiLaunchIndex": 0
                }
            ], 
            "ReservationId": "r-003c6a6a7ed87065f", 
            "Groups": [], 
            "OwnerId": "412508216422"
        }
    ]
}    
```



# 3. SSH KEY TO SECURELY ACCESS FROM OUR LOCAL MACHINE TO THE AWS CLOUD SERVERS
Let's generate the public/private key to securely access from our local machine to the AWS cloud servers
```console
ssh-keygen

    Enter file in which to save the key: /root/.ssh/kryptonite
    ssh-agent bash  # allows to forwarding the key
    ssh-add ~/.ssh/kryptonite  # add to that agent
    ssh-add -l  # to check it is there
```

Modify the ansible configuration file, /etc/ansible/ansible.cfg
by uncommented/putting host_key_checking = False
which will prevent errors with aws when we try to access our server for the first time
```console
host_key_checking = False 
```

Create your own directory
```console
mkdir terransible
```


# 4. The characteristics of the private network:

I have establish a secure way to access network resources, using a trusted VPN.

I have built a Virtual Private Network (VPC) on AWS in wich instances in the private subnet cannot directly access the internet, making them an ideal for hosting critical resources such as application and our "Redis" database servers.


