# 1. Homework: Click Count application

- ## Context - Client needs & Technical environment

The french Startup Click Paradise has developed a click counter application and in a Lean approach
it wants to deliver the evolutions continuously.
You have joined the team as a DevOps profile and your first task is to industrialize
the construction and delivery of the "Click Count" application.

The web application is developed in Java and uses Redis for storing data. The deployments
are always done first on a Staging environment and then, after validation, on the environment of
Production. ...

- ## Goal

Modify the code of the application and use whatever seems relevant to you to fill
the objectives of the company, namely to deliver quickly and automatically the evolutions in
Production.
The infrastructure of the Staging and Production environments must be configured automatically
in order to ensure the sustainability of the solution. 

[Read more ...](docs/enonce.md)

---

# 2. My best solution: A Load Balancing Front JavaEE GlashFish Web-App running on a Kubernetes cluster with a Redis Architecture on AWS cloud provider

Let me summarize what I have successfully managed to deliver:
## As a architecture:

I was concerned about the scalability, the resilience (replica) and the availability. Since then, I designed my architecture around those willings, especially, AWS and Kubernetes helps me for that. 
- #### Back End:
We choose to let the redis cluster managed by AWS. Once the redis cluster on AWS is launched, with can access it through a endpoint.

- #### Front End:
We choose to use a Kubernetes Cluster of JavaEE GlashFist Web-App. Firstly, we created our docker container with a custom JavaEE GlashFist Web Application.


## As a CI/CD pipeline

We provide the best tool to create a CI/CD pipeline such as automation testing, ... :
- #### Git, Maven Build, JUnit Unit & Integration testing, SonarQube, Jenkins

## As a automation deployment
- #### Terraform
We use terraform as a tool of deployment of servers
- #### Ansible
We use ansible as a tool of deployment of configurations

---

# 3. Below, I will provide in the details all the components that I was used:

## Let's design the architecture
- #### [Redis Architecture (Back-end)](docs/redis_architecture.md)
- #### [Web-app (Front-end)](docs/web_app.md)

## Source Control Management
- #### [Git](docs/source_control_management.md)

## Build Automation
- #### [Maven Build](docs/build_automation.md)
- #### [JUnit Unit & Integration testing](docs/maven_unit_test.md)
- #### [SonarQube: Code quality](docs/code_quality.md)

## Continous Integration
- #### [Jenkins](docs/continuous_integration.md)

## Containerization
- #### [Docker, What is it?](docs/docker.md):
  - [for back-end](docs/docker_back-end.md)
  - [for front-end](docs/docker_front-end.md)
- #### [Link network Docker connection between back-end & front-end](docs/docker_networking.md)  
- #### [Docker Compose](docs/docker_compose.md) (No need anymore - Depreciated in our use case)


## Secure Kubernetes Cluster
- #### [Kubernetes, What is it?:](docs/kubernetes.md) 
  - From Docker Compose to Kubernetes: From a single host to multi-hosts: From Dev to Prod
  
- #### Installation
  - [for Resilience: auto-healing containers, no failover ](docs/replication.md)

- #### Scalable: increasing throughput:
  - in front end:
    - [with Web-app pods ](docs/scalability_web-app.md)
    - [with HAProxy as a load balancer to distribute the incoming traffic ](docs/load_balancer_web-app.md)
  - [network link between web-app, front-end & redis, back-end](docs/link_web-app_to_redis.md)
  - in back end, Master-Slaves Redis architecture:
    - [with a Master pod](docs/scalability_redis.md)
    - [with Slave pods](docs/scalability_redis_slaves.md)

## Automated Deployment of the Infrastructure with Terraform

- #### [Terraform, What is it?](docs/terraform_setup.md)
    - [What we plan to build from Infrastructure as Code](docs/terraform_build.md)
    - Presets:
      - [with Local setup & cloud infrastructure AWS credential setup: IAM](docs/terraform_iam.md)
      - [with Variables](docs/terraform_variables.md)
      
    - Network:
      - [with VPC](docs/terraform_vpc.md)
      - [with a Public subnet for the front](docs/terraform_public_subnet.md)
      - [with a Private subnet for the back](docs/terraform_private_subnet.md)
      - [with a Route table for routing and Internet gateway for internet](docs/terraform_routing.md)

    - Security:  
      - [with AWS Ssh key pair](docs/terraform_ssh_key_pair.md)
      - [with Security groups for:](docs/terraform_security_groups.md)
        - [the layer load balancer](docs/terraform_security_groups_load_balancer.md)
        - [the layer front](docs/terraform_security_groups_front.md)
        - [the layer back](docs/terraform_security_groups_back.md)
      
    - Servers:
      - [with 1 Load Balancer](docs/terraform_instance_load_balancer.md)
      - [with 3 EC2 for the front-end](docs/terraform_instance_public.md): 1 master & 2 replicas
      - [with AWS_elasticache_cluster Redis Terraform module for the back-end](docs/terraform_instance_private.md)


## Automated Deployment of the Server Configurations with Ansible

- #### [Ansible, What is it?](docs/ansible.md)
    - [Play the playbook for setting up Kubernetes on Master & Workers nodes](docs/ansible_playbook_kubernetes.md)
    - [Then play the playbook for setting up Kubernetes on Master node](docs/ansible_playbook_kubernetes_controller.md)
    - [Then play the playbook for setting up Kubernetes on Worker nodes](docs/ansible_playbook_kubernetes_workers.md)

# 4. Bonus: Alternative Kubernetes Setups to think for later
- #### [Multi-Master Redis Cluster](docs/kubernetes_multi_master_nodes_setup.md) (Alternative to consider for later - to improve)
- #### [Automated Kubernetes Deployment with EKS / ECS provided by AWS](docs/eks_setup.md) (Alternative to consider for later  - to improve)

Outside this GitHub project above, [I have kept some extra personal notes](docs/outside_project.md)

