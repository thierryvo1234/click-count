# Play the Playbook for setting up Kubernetes - on Master & Workers

First edit the inventory through /etc/ansible/host
according to the Public DNS (IPv4) for each servers found on the EC2 AWS UI Console:
```console
[k8s-master]
aws_public_ipv4_dns_of_master_1_in_availability_zone_a_

[k8s-worker]
aws_public_ipv4_dns_of_worker_1_in_availability_zone_b
aws_public_ipv4_dns_of_worker_2_in_availability_zone_c

[k8s-master:vars]
redis_aws_endpoint=10.123.11.229
```

On terraform, the redis_aws_endpoint must be filled with the IP and not any alias.

You can do it by
going to the AWS UI Console which allows you to get the Redis ElastiCache Endpoint
(eg. rg-redis.feg1ds.ng.0001.euw3.cache.amazonaws.com:6379)

Then, on your local terminal, you can ping the Redis ElastiCache endpoint to get its IP:
```console
ping rg-redis.feg1ds.ng.0001.euw3.cache.amazonaws.com
```


OUTPUT:
```console
PING rg-redis-001.feg1ds.0001.euw3.cache.amazonaws.com (10.123.11.229) 56(84) bytes of data.
```

Now, fill redis_aws_endpoint with its IP in the /etc/ansible/hosts

Edit ansible_playbook_pre_kubernetes.yml:
```console
---
- hosts: all
  name: Setup the pre-requirement of Kubernetes Cluster on all machines
  gather_facts: false
  remote_user: ec2-user
  become: yes

  tasks:
    - name: Install the latest version of telnet, tc
      yum:
        name:
          - telnet
          - tc
        state: latest

    - name: Add Kubernetes repository
      yum_repository:
        name: kubernetes
        description: Kubernetes
        baseurl: https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
        enabled: 1
        gpgcheck: 0
        repo_gpgcheck: 0
        gpgkey: https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
        exclude: kube*

    - name: Disable SELinux
      command: "setenforce 0"
      ignore_errors: yes

    - name: Disable SELinux in the config file
      replace:
        path: /etc/selinux/config
        regexp: '^SELINUX=enforcing$'
        replace: 'SELINUX=permissive'

    - name: Install Kubelet, Kubeadm, Kubectl
      yum:
        name:
          - kubelet
          - kubeadm
          - kubectl
        state: latest
        disable_excludes: kubernetes

    - name: Start service kubelet
      service:
        name: kubelet
        state: started
        enabled: yes

    - name: Configure the bridge network
      block:
        - name: Configure the bridge network - ipv4
          lineinfile:
            path: /etc/sysctl.d/k8s.conf
            create: yes
            line: net.bridge.bridge-nf-call-ip6tables = 1

        - name: Configure the bridge network - ipv6
          lineinfile:
            path: /etc/sysctl.d/k8s.conf
            create: yes
           line: net.bridge.bridge-nf-call-iptables = 1

        - name: Apply the bridge network configuration"
          command: "sysctl --system"
    
    - name: Disable swap
      block:      
        - name: Disable swap
          command: "swapoff -a"
          
        - name: Disable swap through kubeadm configuration
          lineinfile:
            path: /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
            line: Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"

    - name: Add Docker repository
      command: "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"

    - name: Install SeLinux from a remote repo - Requirement of Docker
      yum:
        name: http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.68-1.el7.noarch.rpm
        state: present

    - name: Install Docker
      yum:
        name: docker-ce-18.06.1.ce-3.el7
        state: present

    - name: Restart Docker, Kubelet
      service:
        name: "{{ item }}"
        state: restarted
        daemon_reload: yes
        enabled: yes
      with_items:
        - docker
        - kubelet

```

Finally, launch:
```console
ansible-playbook ansible_playbook_pre_kubernetes.yml 
```
