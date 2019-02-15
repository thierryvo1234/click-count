# Ansible

## Orchestration (Terraform) vs Configuration Management (Ansible)

Although Terraform & CloudFormation are orchestration tools and are designed to provision the servers themselves,
Ansible is a configuration management and provisioning tool, similar to Chef, Puppet or Salt. It is designed to install and manage softwares on existing servers 

So, we use Terraform to provision infrastructure resources, 
then pass the baton to Ansible, to install and configure software components.

## Ansible characteristics

Ansible uses these facts to check the state and see if it needs to change anything in order to get the desired outcome. This makes it safe to run Ansible Tasks against a server over and over again.

## Install

Of course, we need to start by installing Ansible. Tasks can be run off of any machine Ansible is installed on.

This means there's usually a "central" server running Ansible commands, although there's nothing particularly special about what server Ansible is installed on. Ansible is "agentless" - there's no central agent(s) running. We can even run Ansible from any server; I often run Tasks from my laptop.

### Managing Servers

Ansible has a default inventory file used to define which servers it will be managing. After installation, there's an example one you can reference at /etc/ansible/hosts.

I usually copy and move the default one so I can reference it later:
```console
sudo mv /etc/ansible/hosts /etc/ansible/hosts.orig
```

Check the available EC2 instance on AWS WEB UI Console
and attribute the 3 EC2 instances to 1 controller and 2 workers

Edit /etc/ansible/hosts to something similar to below:
```console
[kubernetes_master]
ec2-35-180-172-87.eu-west-3.compute.amazonaws.com

[kubernetes_worker]
ec2-35-180-28-196.eu-west-3.compute.amazonaws.com
ec2-35-180-227-12.eu-west-3.compute.amazonaws.com
```

I usually copy and move the default one so I can reference it later:
```console
sudo mv /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg.orig
```


Edit /etc/ansible/ansible.cfg by replacing 
```console
#private_key_file = /path/to/file
```
to:
```console
private_key_file = /root/.ssh/clickcount-auth
```



# Basic: Running Commands

Once we have an inventory configured, we can start running Tasks against the defined servers.

```console
ansible -m ping all -i /etc/ansible/hosts --private-key=/root/.ssh/clickcount-auth -u ec2-user
```


