
# Then play the playbook for setting up Kubernetes on Worker nodes

Edit ansible_kubernetes_worker.yml :
```console
---
- hosts: k8s-worker
  remote_user: ec2-user
  become: yes
  gather_facts: no

  tasks:

    - name: Copy the file result_kubeadm_init to workers
      copy:
        src: /apps/terransible/tmp/result_kubeadm_init.txt
        dest: /home/ec2-user/result_kubeadm_init.txt
        owner: ec2-user
        group: ec2-user
        mode: 0644

    - name: Grep the kubeadm join to join the worker to the Kubernetes cluster
      command: "grep 'kubeadm join' /home/ec2-user/result_kubeadm_init.txt"
      register: join_command

    - name: Play the command Kubeadm join command
      command: "{{ join_command.stdout_lines[0] }}"
```

Launch:
```console
ansible-playbook ansible_kubernetes_worker.yml 
```

Now you can connect to the Kubernetes master nodes by typing on my local machine:
```console
ssh ec2-user@ec2-35-180-158-36.eu-west-3.compute.amazonaws.com -i /root/.ssh/clickcount-auth
```

Once I am connected to the remote Kubernetes master node, I can check that my Kubernetes Cluster is running by typing:
```console
kubectl get nodes
```

OUTPUT:
```console
NAME                                         STATUS   ROLES    AGE     VERSION
ip-10-123-0-174.eu-west-3.compute.internal   Ready    master   11m     v1.13.3
ip-10-123-1-164.eu-west-3.compute.internal   Ready    <none>   9m30s   v1.13.3
ip-10-123-2-175.eu-west-3.compute.internal   Ready    <none>   9m30s   v1.13.3
```
