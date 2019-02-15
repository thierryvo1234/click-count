# From a single host to multi-hosts
## From Docker Compose to Kubernetes - From Dev to Prod

Difference between Docker compose and Kubernetes: 
One difference to note is that Docker Compose runs on a single host, whereas Kubernetes typically uses multiple nodes, which can be added or removed dynamically.


# Kubernetes Cluster
Kubernetes is an open-source platform created by Google for container deployment operations, scaling up and down, and automation across the clusters of hosts. This production-ready, enterprise-grade, self-healing (auto-scaling, auto-replication, auto-restart, auto-placement) platform is modular, and so it can be utilized for any architecture deployment.

Kubernetes also distributes the load amongst containers. It aims to relieve the tools and components from the problem faced due to running applications in private and public clouds by placing the containers into groups and naming them as logical units. Their power lies in easy scaling, environment agnostic portability, and flexible growth.

## Application definition
Kubernetes: An application can be deployed in Kubernetes utilizing a combination of services (or microservices), deployments, and pods.

## Networking
Kubernetes: The networking model is a flat network, allowing all pods to interact with one another. The network policies specify how pods interact with each other. The flat network is implemented typically as an overlay. The model needs two CIDRs: one for the services and the other from which pods acquire an IP address.

## Scalability
Kubernetes: For distributed systems, Kubernetes is more of an all-in-one framework. It is a complex system because it provides strong guarantees about the cluster state and a unified set of APIs. This slows down container scaling and deployment.

## High Availability
Kubernetes: All the pods in kubernetes are distributed among nodes and this offers high availability by tolerating the failure of the application. Load balancing services in kubernetes detect unhealthy pods and get rid of them. So, this supports high availability.

## Container Setup
Kubernetes: Kubernetes utilizes its own YAML, API, and client definitions and each of these differs from that of standard docker equivalents. That is to say, you cannot utilize Docker Compose nor Docker CLI to define containers. While switching platforms, YAML definitions, and commands need to be rewritten.

## Load Balancing
Kubernetes: Pods are exposed via service, which can be utilized as a load balancer within the cluster. Generally, an ingress is utilized for load balancing.


# Services included in Kubernetes, the open-source platform

We could mount persistent volumes that would allow us to move containers without losing data, it used flannel to create networking between containers, it has load balancer integrated, it uses etcd for service discovery, and so on. However, Kubernetes comes at a cost. It uses a different CLI, different API and different YAML definitions. In other words, you cannot use Docker CLI nor you can use Docker Compose to define containers.


