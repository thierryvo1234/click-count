# with playbook for setting up Docker




Edit ansible_setup_docker.yml
```console
---
- hosts: all
  name: Setup Docker
  gather_facts: false
  remote_user: ec2-user
  become: yes

  tasks:
    - name: "Installing Docker Prerequisite packages 1/2"
      yum:
        name: ['yum-utils', 'device-mapper-persistent-data', 'lvm2']
        state: latest

    - name: "Installing Docker (version 17.03)"
      yum:
        name:
          - https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
          - https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
        state: present

    - name: "Starting and Enabling Docker service"
      service:
        name: docker
        state: started
        enabled: yes
```
