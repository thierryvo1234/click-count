# Why do we need Docker?

The short list of benefits includes:

_ faster development process

_ handy application encapsulation

_ the same behavior on local machine / dev / staging / production servers

_ distribute the whole app including the "server" in a ready-to-run state

_ easy and clear monitoring

_ easy to scale. Automation to provision

_ better than Virtual Machine (VM)


- ### Faster development process
There is no need to install 3rd-party apps like PostgreSQL, Redis, or Elasticsearch on the system — you can run them in containers.

Docker also gives you the ability to run different versions of the same application simultaneously. For example, say you need to do some manual data migration from an older version of Postgres to a newer version. You can have such a situation in microservice architecture when you want to create a new microservice with a new version of the 3rd-party software.

It could be quite complex to keep two different versions of the same app on one host OS. In this case, Docker containers could be a perfect solution — you receive isolated environments for your applications and 3rd-parties.



- ### Handy application encapsulation

With Docker, you can easily deploy a web application along with its dependencies, environment variables, and configuration settings - everything you need to recreate your environment quickly and efficiently.

You can deliver your application in one piece. Most programming languages, frameworks, and all operating systems have their own packaging managers. And even if your application can be packed with its native package manager, it could be hard to create a port for another system.

Docker gives you a unified image format to distribute your applications across different host systems and cloud services. You can deliver your application in one piece with all the required dependencies (included in an image) ready to run.

The same behavior on local machine / dev / staging / production servers
Docker can’t guarantee 100% dev / staging / production parity, because there is always the human factor. But it reduces to almost zero the probability of error caused by different versions of operating systems, system-dependencies, and so forth.

With the right approach to building Docker images, your application will use the same base image with the same OS version and the required dependencies.



- ### Easy and clear monitoring

Out of the box, you have a unified way to read log files from all running containers. You don’t need to remember all the specific paths where your app and its dependencies store log files, and write custom hooks to handle this. 
You can integrate an external logging driver and monitor your app log files in one place.



- ### Easy to scale

A correctly wrapped application will cover most of the Twelve Factors. By design, Docker forces you follow its core principles, such as configuration over environment variables, and communication over TCP/UDP ports. And if you’ve done your application right, it will be ready for scaling not only in Docker.

- ### Better than Virtual Machine (VM)

Even if Virtual Machine is a virtualization tool that helps us to spin up new production servers when we need to
compare to traditional architecture.

Virtual Machine is nowadays:
- slower
- using a lot of resources
- not portable
- not offering that the code is deployed in the same way on all the VM
compare to the containerization offered by Docker

What if we have something like a kind of VM, but faster, smaller and easier to work with than a VM. That's what Docker offered. We could package the code and the system-level configuration (entire OS, and simulations of all the hardware) in a lightweight package that can stand up quickly and run almost anywhere.

It is lightweight because the container has only what the app needs in order to run. Moreover, orchestration becomes much easier with container thanks to its lightweight.



# Docker-specific terms
- A Dockerfile is a file that contains a set of instructions used to create an image.
- An image is used to build and save snapshots (the state) of an environment.
- A container is an instantiated, live image that runs a collection of processes.

# Install docker
```console
sudo yum -y install docker
sudo groupadd docker
sudo usermod -aG docker user
sudo systemctl start docker
sudo systemctl enable docker
```

In production, run the container with the restart policy,
docker will actually take care of making sure that the container is always running
if the application inside the container crashes, docker will automatically recreate the container.
If the server itself restart or if the docker service restart, docker will make sure that it stands up that container again.
As long as we explicitly don't stop the container, docker makes that the container is always running.
That's all we need to do to actually to do to get our application to run on production

```console
docker run --restart always
```


### Check docker is running, Create DockerFile and save it on the Hub
```console
docker pull docker.io/hello-world
docker images
docker run hello-world
docker ps -a
```

An image is defined in a Dockerfile. When you build, you give your image a name (and possibly tags).
Once you build the image, you can create and run a container instance:
```console
docker build -t <docker username>/<image-name> .
docker images
docker run -d <docker username>/<image-name> 
docker ps
```

Once you "docker build" an image, you can "docker push" it to the registry.
Then you can "docker run" that image from anywhere that is set up to access that registry.
You can maintain your own private registries or you can use the official cloud registry, Docker Hub (hub.docker.com)
To authenticate with Docker Hub:
```console
docker login
docker push
```


# Dockerfile

The Dockerfile defines the docker images that will be built. It consists of a series of instructions for producing the image:
- FROM, sets the parent image that I want to build the image from
- WORKDIR, sets the current working directory inside the container image for other commands where the source will be put at
- COPY, copies files from the host into the container image, eg. copy all the source code that is in the folder that I cloned from my GitHub and then I am going to copy into the current directory inside the image
- RUN, executes a command within the container image
- EXPOSE, tells docker that the application in the container listens on a particular ports
- CMD, sets the command that is executed by the container when it is run. Whenever I run a container based on that image, it is going to run the command inside the working directory


```console
git clone https://github.com/<your git username>/<your git repository>
cd <your git repository> 
vi Dockerfile
```

# Install Docker on a Jenkins server
 
 Install and configure the user right to be able to access it.
 In particular, add the user jenkins to the group docker
 ```console
sudo yum -y install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo systemctl restart docker
```
 
```console 
mvn package
```

Edit Dockerfile
```console
FROM glassfish:latest

MAINTAINER Thierry VO <thierrylam.vo@gmail.com>

USER root

COPY click-count/target/clickCount.war /
COPY start.sh /

EXPOSE 8080

ENTRYPOINT ["/start.sh"]
```

Edit start.sh
```console
#!/bin/sh

/usr/local/glassfish4/bin/asadmin start-domain
/usr/local/glassfish4/bin/asadmin -u admin deploy /clickCount.war
/usr/local/glassfish4/bin/asadmin stop-domain
/usr/local/glassfish4/bin/asadmin start-domain --verbose
```

```console
sudo chmod +x ./start.sh
```

```console
docker build --no-cache -t terryv8/clickcount .
docker run -p 8080:8080 terryv8/clickcount
```

2 docker containers:

This creates a new container called redis from the redis image, which contains a redis database.
```console
docker run --rm --name redis -p 6379:6379 -d redis
```

Links allow containers to discover each other and securely transfer information about one container to another container. When you set up a link, you create a conduit between a source container and a recipient container. The recipient can then access select data about the source. To create a link, you use the --link flag. 
Now, create a new app container and link it with your redis database container.
```console
docker build --no-cache -t terryv8/my-app-redis -f Dockerfile-app .
docker run --name my-app-redis -p 8080:8080 -d --link=redis terryv8/my-app-redis
```

Execute inside the container:
```console
docker exec -it my-app-redis bash
```

So what does linking the containers actually do? You’ve learned that a link allows a source container to provide information about itself to a recipient container. In our example, the recipient, web, can access information about the source db. To do this, Docker creates a secure tunnel between the containers that don’t need to expose any ports externally on the container; when we started the db container we did not use either the -P or -p flags. That’s a big benefit of linking: we don’t need to expose the source container, here the PostgreSQL database, to the network.

Docker exposes connectivity information for the source container to the recipient container in two ways:
- Environment variables,
- Updating the /etc/hosts file.




In this part, we shall take a look at how to link Docker Containers. By linking containers, you provide a secure channel via which Docker containers can communicate with each other.

Think of a sample web application. You might have a Web Server and a Database Server. When we talk about linking Docker Containers, what we are talking about here is the following:

We can launch one Docker container that will be running the Database Server.
We will launch the second Docker container (Web Server) with a link flag to the container launched in Step 1. This way, it will be able to talk to the Database Server via the link name.
This is a generic and portable way of linking the containers together rather than via the networking port that we saw earlier in the series. Keep in mind that this chapter covers Linking Containers via the — link flag. A new tool Docker Compose is the recommended way moving forward but for this tutorial, I will cover the — link flag only and leave it to the reader to look at Docker Compose.

Let us begin first by launching the popular NoSQL Data Structure Server Redis. Like other software, Redis has its official Docker image available in the Docker Hub as well.

First, let us pull down the Redis image via the following command:

```console
$ docker pull redis
```
Next, let us launch a Redis container (named redis1) in the detached mode  as follows:

```console
$ docker run -d --name redis1 redis
37f174130f758083d243541e8adab7e2d8be2012e555cbdbd5fc67ca9d26526d
```
We can check that redis1 container has started via the following command:

```console
$ docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
37f174130f75 redis "/entrypoint.sh redi 30 seconds ago Up 29 seconds 6379/tcp redis1
```
Notice that it has started on port 6379.

Now, let us run another container, a busybox container as shown below:

```console
$ docker run -it --link redis1:redis --name redisclient1 busybox
```
Notice the — link flag. The value provided to the — link flag is sourcecontainername:containeraliasname. We have chosen the value redis1 in the sourcecontainername since that was the name that was given to the first container that we launched earlier. The containeraliasname has been selected as redis and it could be any name of your choice.

The above launch of container (redisclient1) will lead you to the shell prompt.

Now, what has this launch done for you? Let us observe first what entry has got added in the /etc/hosts file of the redisclient1 container:

```console
/ # cat /etc/hosts
172.17.0.23 26c37c8982e9
127.0.0.1 localhost
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.21 redis 37f174130f75 redis1
/ #
```
Notice an entry at the end, where the container redis1 has got associated with the redis name.

Now, if you do a ping by the hostname i.e. alias name (redis) — it will work:

```console
/ # ping redis
PING redis (172.17.0.21): 56 data bytes
64 bytes from 172.17.0.21: seq=0 ttl=64 time=0.218 ms
64 bytes from 172.17.0.21: seq=1 ttl=64 time=0.135 ms
64 bytes from 172.17.0.21: seq=2 ttl=64 time=0.140 ms
64 bytes from 172.17.0.21: seq=3 ttl=64 time=0.080 ms
```
If you print out the environment variables you will see the following (I have removed the other environment variables):

```console
/ # set
....
REDIS_ENV_REDIS_DOWNLOAD_SHA1='0e2d7707327986ae652df717059354b358b83358'
REDIS_ENV_REDIS_DOWNLOAD_URL='http://download.redis.io/releases/redis-3.0.3.tar.gz'
REDIS_ENV_REDIS_VERSION='3.0.3'
REDIS_NAME='/redisclient1/redis'
REDIS_PORT='tcp://172.17.0.21:6379'
REDIS_PORT_6379_TCP='tcp://172.17.0.21:6379'
REDIS_PORT_6379_TCP_ADDR='172.17.0.21'
REDIS_PORT_6379_TCP_PORT='6379'
REDIS_PORT_6379_TCP_PROTO='tcp'
....
```
You can see that various environment variables were auto-created for you to help reach out to the redis1 server from the redisclient1.

Sounds good? Now, let us get a bit more adventurous.

Exit the redis1 container and come back to the terminal.

Let us launch a container based on the redis image but this time instead of the default command that will launch the redis server, we will simply go into the shell so that all the redis client tools are ready for us. Note that the redis1 server (container) that we launched is still running.

$ docker run -it --link redis1:redis --name client1 redis sh
This will lead you to the prompt. Do a ping of redis i.e. our alias name and it should work fine.

# ping redis
```console
PING redis (172.17.0.21): 48 data bytes
56 bytes from 172.17.0.21: icmp_seq=0 ttl=64 time=0.269 ms
56 bytes from 172.17.0.21: icmp_seq=1 ttl=64 time=0.248 ms
56 bytes from 172.17.0.21: icmp_seq=2 ttl=64 time=0.205 ms
```
Next thing is to launch the redis client (redis-cli) and connect to our redis server (running in another container and to which we have linked) as given below:

# redis-cli -h redis
```console
redis:6379>
```
You can see that we have been able to successfully able to connect to the redis server via the alias name that we specified in the — link flag while launching the container. Of course if we were running the Redis server on another port (other than the standard 6379) we could have provided the -p parameter to the redis-cli command and used the value of the environment variable over here (REDIS_PORT_6379_TCP_PORT). Hope you are getting the magic!

Now, let us execute some standard Redis commands:

```console
redis:6379> PING
PONG
redis:6379> set myvar DOCKER
OK
redis:6379> get myvar
"DOCKER"
redis:6379>
```
Everything looks fine. Let us exit this container and launch another client (client2) that wants to connect to the same Redis Server that is still running in the first container that we launched and to which we added a string key / value pair.

$ docker run -it --link redis1:redis --name client2 redis sh
Once again, we execute a few commands to validate things:

# redis-cli -h redis
```console
redis:6379> get myvar
"DOCKER"
redis:6379>
```
You are all set now to link containers together.

Additional Reading
Check out Docker Compose, which provides a mechanism to do the linking but by specifying the containers and their links in a single file. Then all one needs to do is use the docker-compose tool to run this file and it will figure out the relationships (which container needs to launch first, etc) and launch the containers for you. Moving forward, do expect Docker Compose to be the standard way to do linking.
