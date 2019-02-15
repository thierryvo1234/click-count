# Multi-Master Redis Cluster

The solution that we provided until now, could be a good solution since we used multiple replicas.
However, we can also consider the "Multi-Master Redis Cluster" that might provide a better solution for managing the failover behavior.

Here is some source:
- https://medium.com/velotio-perspectives/demystifying-high-availability-in-kubernetes-using-kubeadm-3d83ed8c458b
- https://medium.com/devopslinks/configuring-ha-kubernetes-cluster-on-bare-metal-servers-with-kubeadm-1-2-1e79f0f7857b
- https://kubernetes.io/docs/setup/independent/high-availability/
- https://www.dadall.info/article676/kubernetes-en-multi-master-sur-du-baremetal-avec-haproxy
- https://medium.com/@bambash/ha-kubernetes-cluster-via-kubeadm-b2133360b198
- https://blog.inkubate.io/install-and-configure-a-multi-master-kubernetes-cluster-with-kubeadm/
- https://translate.google.com/translate?hl=&sl=auto&tl=en&u=https%3A%2F%2Fkazuhisya.netlify.com%2F2018%2F02%2F08%2Fhow-to-install-k8s-on-el7%2F
