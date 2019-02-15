# We have successfully build a Front JavaEE GlashFish Web-App running on a Kubernetes cluster with a Redis Architecture on AWS cloud provider

## As a architecture:

- #### Back End:
We choose to let the redis cluster managed by AWS with provided us all the quality of services such as the scalability, the resilience (replica) and the health. Once the redis cluster on AWS is launched, with can access it through a endpoint (eg.)

- #### Front End:
We choose to use a Kubernetes Cluster of JavaEE GlashFist Web-App which allows us to manage the scalability and the resilience (replica) as well. Firstly, we created our docker container with a custom JavaEE GlashFist Web Application.


## As a CI/CD pipeline

We provide the best tool to create a CI/CD pipeline such as automation testing, ... :
- #### Git, Maven Build, JUnit Unit & Integration testing, SonarQube, Jenkins

## As a automation deployment
- #### Terraform
We use terraform as a tool of deployment of servers
- #### Ansible
We use ansible as a tool of deployment of configurations




