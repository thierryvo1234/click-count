# Then play the playbook for setting up Kubernetes on Master node

Edit ansible_kubernetes_master.yml:

```console
---
- hosts: k8s-master
  remote_user: ec2-user
  become: yes
  gather_facts: no

  tasks:
    - name: Kubeadm init
      command: "kubeadm init --pod-network-cidr=10.244.0.0/16"
      ignore_errors: yes
      register: resulut_kubeadm_init

    - local_action: "copy content='{{ resulut_kubeadm_init.stdout }}' dest=/apps/terransible/tmp/result_kubeadm_init.txt"

    - name: Create .kube directory
      file:
        path: /home/ec2-user/.kube
        state: directory
        mode: 0755
        owner: ec2-user
        group: ec2-user

    - name: Copy admin.conf to user's kube config on the remote master machine
      copy:
        src: /etc/kubernetes/admin.conf
        dest: /home/ec2-user/.kube/config
        remote_src: yes
        owner: ec2-user
        group: ec2-user

    - name: Install Pod network - No need for root priviledge
      become: no
      become_user: ec2-user
      command: "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
```

In my case, I have a local folder named /apps/terransible/tmp/ - on my localhost in wich I will save the result of the kubeadm init command. It will help us to use that information for the workers nodes to join the Redis cluster.


Launch the command:
```console
ansible-playbook ansible_kubernetes_master.yml
```
