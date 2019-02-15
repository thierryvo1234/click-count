# Docker Compose

Docker Compose is an orchestration framework that handles the building and running of multiple services (via separate containers) using a simple .yml file. 
It uses to link services together running in different containers.

Let's install docker-compose:
```console
pip install docker-compose
```

In this example, I am going to connect Python and Redis containers.

```console
version: '2'
services:
  app:
    build:
      context: .
    depends_on:
      - redis
    environment:
      - REDIS_HOST=redis
    ports:
#      - "8080:8080"
      - "5000:5000"
  redis:
    image: redis
#    volumes:
#      - redis_data:/data
    ports:
      - "6379:6379"
# volumes:
#  redis_data:

```

Go to examples/compose and execute the following command:
```console
docker-compose rm -f
docker-compose pull
docker-compose up --build -d
# Run some tests
./tests
docker-compose stop -t 1
```


```console
docker-compose --project-name app-test -f docker-compose.yml up --force-recreate 
```

Console output:
```console
Creating network "apptest_default" with the default driver  
Creating volume "apptest_redis_data" with default driver  
Pulling redis (redis:3.2-alpine)...  
3.2-alpine: Pulling from library/redis  
627beaf3eaaf: Pull complete  
a503a4771a4a: Pull complete  
72c5d910c683: Pull complete  
6aadd3a49c30: Pull complete  
adf925aa1ad1: Pull complete  
0565da0f872e: Pull complete  
Digest: sha256:9cd405cd1ec1410eaab064a1383d0d8854d1eef74a54e1e4a92fb4ec7bdc3ee7  
Status: Downloaded newer image for redis:3.2-alpine  
Building app  
Step 1/9 : FROM python:3.5.2-alpine  
3.5.2-alpine: Pulling from library/python  
b7f33cc0b48e: Pull complete  
8eda8bb6fee4: Pull complete  
4613e2ad30ef: Pull complete  
f344c00ca799: Pull complete  
Digest: sha256:8efcb12747ff958de32b32424813708f949c472ae48ca28691078475b3373e7c  
Status: Downloaded newer image for python:3.5.2-alpine  
 ---> e70a322afafb
Step 2/9 : ENV BIND_PORT 5000  
 ---> Running in 8518936700b3
 ---> 0f652cdd2cee
Removing intermediate container 8518936700b3  
Step 3/9 : ENV REDIS_HOST localhost  
 ---> Running in 027286e90699
 ---> 6da3674f79fa
Removing intermediate container 027286e90699  
Step 4/9 : ENV REDIS_PORT 6379  
 ---> Running in 0ef17cb512ed
 ---> c4c514aa3008
Removing intermediate container 0ef17cb512ed  
Step 5/9 : COPY ./requirements.txt /requirements.txt  
 ---> fd523d64faae
Removing intermediate container 8c94c82e0aa8  
Step 6/9 : COPY ./app.py /app.py  
 ---> be61f59b3cd5
Removing intermediate container 93e38cd0b487  
Step 7/9 : RUN pip install -r /requirements.txt  
 ---> Running in 49aabce07bbd
Collecting flask==0.12 (from -r /requirements.txt (line 1))  
  Downloading Flask-0.12-py2.py3-none-any.whl (82kB)
Collecting redis==2.10.5 (from -r /requirements.txt (line 2))  
  Downloading redis-2.10.5-py2.py3-none-any.whl (60kB)
Collecting itsdangerous>=0.21 (from flask==0.12->-r /requirements.txt (line 1))  
  Downloading itsdangerous-0.24.tar.gz (46kB)
Collecting Werkzeug>=0.7 (from flask==0.12->-r /requirements.txt (line 1))  
  Downloading Werkzeug-0.11.15-py2.py3-none-any.whl (307kB)
Collecting Jinja2>=2.4 (from flask==0.12->-r /requirements.txt (line 1))  
  Downloading Jinja2-2.9.5-py2.py3-none-any.whl (340kB)
Collecting click>=2.0 (from flask==0.12->-r /requirements.txt (line 1))  
  Downloading click-6.7-py2.py3-none-any.whl (71kB)
Collecting MarkupSafe>=0.23 (from Jinja2>=2.4->flask==0.12->-r /requirements.txt (line 1))  
  Downloading MarkupSafe-1.0.tar.gz
Installing collected packages: itsdangerous, Werkzeug, MarkupSafe, Jinja2, click, flask, redis  
  Running setup.py install for itsdangerous: started
    Running setup.py install for itsdangerous: finished with status 'done'
  Running setup.py install for MarkupSafe: started
    Running setup.py install for MarkupSafe: finished with status 'done'
Successfully installed Jinja2-2.9.5 MarkupSafe-1.0 Werkzeug-0.11.15 click-6.7 flask-0.12 itsdangerous-0.24 redis-2.10.5  
 ---> 18c5d1bc8804
Removing intermediate container 49aabce07bbd  
Step 8/9 : EXPOSE $BIND_PORT  
 ---> Running in f277fa7dfcd5
 ---> 9f9bec2abf2e
Removing intermediate container f277fa7dfcd5  
Step 9/9 : CMD python /app.py  
 ---> Running in a2babc256093
 ---> 2dcc3b299859
Removing intermediate container a2babc256093  
Successfully built 2dcc3b299859  
WARNING: Image for service app was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.  
Creating apptest_redis_1  
Creating apptest_app_1  
Attaching to apptest_redis_1, apptest_app_1  
redis_1  | 1:C 08 Mar 09:56:55.765 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf  
redis_1  |                 _._  
redis_1  |            _.-``__ ''-._  
redis_1  |       _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit  
redis_1  |   .-`` .-```.  ```\/    _.,_ ''-._  
redis_1  |  (    '      ,       .-`  | `,    )     Running in standalone mode  
redis_1  |  |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379  
redis_1  |  |    `-._   `._    /     _.-'    |     PID: 1  
redis_1  |   `-._    `-._  `-./  _.-'    _.-'  
redis_1  |  |`-._`-._    `-.__.-'    _.-'_.-'|  
redis_1  |  |    `-._`-._        _.-'_.-'    |           http://redis.io  
redis_1  |   `-._    `-._`-.__.-'_.-'    _.-'  
redis_1  |  |`-._`-._    `-.__.-'    _.-'_.-'|  
redis_1  |  |    `-._`-._        _.-'_.-'    |  
redis_1  |   `-._    `-._`-.__.-'_.-'    _.-'  
redis_1  |       `-._    `-.__.-'    _.-'  
redis_1  |           `-._        _.-'  
redis_1  |               `-.__.-'  
redis_1  |  
redis_1  | 1:M 08 Mar 09:56:55.767 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.  
redis_1  | 1:M 08 Mar 09:56:55.767 # Server started, Redis version 3.2.8  
redis_1  | 1:M 08 Mar 09:56:55.767 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.  
redis_1  | 1:M 08 Mar 09:56:55.767 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.  
redis_1  | 1:M 08 Mar 09:56:55.767 * The server is now ready to accept connections on port 6379  
app_1    |  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)  
app_1    |  * Restarting with stat  
app_1    |  * Debugger is active!  
app_1    |  * Debugger pin code: 299-635-701  
```

Current example will increment view counter in Redis. Open the following url as described in your web browser and check it.

To see volumes run:
```console
docker volume ls  
```

OUTPUT:
```console
DRIVER              VOLUME NAME  
local               apptest_redis_data
```




Now let’s get web application up and running along with Redis:

Here we add the services that make up our stack:

1. web: First, we build the image from the “web” directory and then mount that directory to the “code” directory within the Docker container. The Flask app is ran via the python app.py command. This exposes port 5000 on the container, which is forwarded to port 80 on the host environment.
2. redis: Next, the Redis service is built from the Docker Hub “Redis” image. Port 6379 is exposed and forwarded.


```console
version: '1.0'
services:
  java-web-frontend:
    image: TerryV8/click-count
    container_name: java-web-frontend
    hostname: java-web-frontend
    env_file: java-web-frontend.env
    restart: always
    ports:
      - "8080:8080"
    volumes:
      - .:/code
    depends_on:
      - redis

  redis:
    image: redis
#    volumes:
#      - /redis_data:/data
```

```console
version: '1.0'
services:
  java-web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/code
    depends_on:
      - redis

  redis:
    image: redis
#    volumes:
#      - /redis_data:/data
```



```console
version: '1.0'  
services:  
  app:
    build:
      context: ./app
    depends_on:
      - redis
    environment:
      - REDIS_HOST=redis
    ports:
      - "6379:6379"
  redis:
    image: redis:3.2-alpine
    volumes:
      - redis_data:/data
volumes:  
  redis_data:
```
  
How to Read the Docker Compose File:
- We define two services, web and redis.
- The web service builds from the Dockerfile in the current directory
- Forwards the container’s exposed port (5000) to port 5000 on the host…
- Mounts the project directory on the host to /code inside the container (allowing you to modify the code without having to rebuild the image)…
- And links the web service to the Redis service.
- The redis service uses the latest Redis image from Docker Hub.





Alpine images

A lot of Docker images (versions of images) are created on top of Alpine Linux – this is a lightweight distro that allows you to reduce the overall size of Docker images.

I recommend that you use images based on Alpine for third-party services, such as Redis, Postgres, etc. For your app images, use images based on buildpack – it will be easy to debug inside the container, and you’ll have a lot of pre-installed system-wide requirements.

Only you can decide which base image to use, but you can get the maximum benefit by using one basic image for all images because in this case the cache will be used more effectively.
  

Volume — can be described as a shared folder. Volumes are initialized when a container is created. Volumes are designed to persist data, independent of the container’s lifecycle. So, be careful with volumes. You should remember what data is in volumes. Because volumes are persistent and don’t die with the containers, the next container will use data from the volume created by the previous container.

# Build and Run
With one simple command, we can build the image and run the container.
Start the application from the current directory:
```console
docker-compose up --build
```

If you have localhost access to your host (i.e., you do not use a remote solution to deploy Docker), point your browser to http://0.0.0.0:5000, http://127.0.0.1:5000, or http://localhost:5000. On a Mac, you need to use docker-machine ip MACHINE_VM to get your Docker host’s IP address (then use that address like http://MACHINE_IP:5000 to access your web page). If you do use a remote host, simply use that IP address and append :5000 to the end.


Docker Compose brings each container up at once in parallel.

Open your web browser and navigate to the IP address associated with the DOCKER_HOST variable - i.e., http://192.168.59.103/, in this example. (Run boot2docker ip to get the address.)

You should see the text, “Hello! This page has been seen 1 times.” in your browser:

![docker_compose_build_run](https://files.realpython.com/media/test.6e35b0692889.png)

Refresh. The page counter should have incremented.

To run the process in the background. Kill our current processes (Ctrl+C), and then run the following command :
```console
docker-compose up -d --build
```

If you want to view the currently running processes?
```console
docker-compose ps
```

The output looks like this:
Name                          Command             State              Ports
--------------------------------------------------------------------------------------------------
fitterhappierdocker_redis_1     /entrypoint.sh redis-server   Up      0.0.0.0:6379->6379/tcp
fitterhappierdocker_web_1       python app.py                 Up      0.0.0.0:80->5000/tcp, 80/tcp

Both processes are running in a different container, connected via Docker Compose!


# Why link docker containers?

You should be running a single process per docker container, this means your application code (say nodejs) and your database (say postgres) need to be running in their own containers. Potentially on different servers if you have a swarm or cluster of hosts.
Therefore connecting two containers together in docker is essential. So how do you do it?


# Using docker network

Connecting containers is simple. You just add them to the same docker network. If you only have a single host then it will come with a pre-configured bridge network called bridge that you can use without any extra work.

```console
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
10735ef1e95f        bridge              bridge              local
85274e9bac4e        host                host                local
b9d9f025e8bb        none                null                local
```

But you can also create your own easily enough. You can create as many as you like to isolate groups of containers.

```console
$ docker network create --driver=bridge my-network-redis-web
4114eb9b91a55df8380da5ce5b288e7a7b1841b59366368b8f35e4437b2fcd25
```

```console
$ docker network ls
NETWORK ID          NAME                    DRIVER              SCOPE
10735ef1e95f        bridge                  bridge              local
85274e9bac4e        host                    host                local
4114eb9b91a5        my-network-redis-web    bridge              local
b9d9f025e8bb        none                    null                local
```

In a multi-host environment use the overlay driver to create a network that spans across the hosts. That is a topic for another post.

Once you have a network, there are two ways to connect a container to it.
If you are starting a fresh container, simply add --net=my-network to the docker run command.
If you have an existing container, then run docker network connect my-network my-container.
Let's test it out by creating two connected containers, drop in to their shells and do some pinging.

# In terminal 1
```console
$ docker run --rm -it --net=my-network --name container1 centos bash
```

# In terminal 2
```console
$ docker run --rm -it --net=my-network --name container2 centos bash
```

Why networks and not links or compose
The other things I have seen people say on twitter is to use links (largely deprecated now) or compose (the utter wrong tool for the job).

Networks are the right answer, they handle container restarts and ip changes, and the abstraction holds across swarms and multi-host networks. In addition they are as simple as can be. So ignore the other stuff and just use them!


What about ports?

Another benefit here is that ports between the containers are opened. So if you were previously exposing ports to the host just so another container could access it you, can stop doing that.

Let's open a third terminal window and add a memcached instance to our network.

# In terminal 3
```console
$ docker run --rm --net my-network --name memcached memcached
```

# In terminal 1 or 2
```console
[root@acefce27fa79 /]# yum install telnet
[root@acefce27fa79 /]# telnet memcached 11211
Trying 172.18.0.4...
Connected to memcached.
Escape character is '^]'.
flush_all
OK
```

Here we can see we were able to add a new container to the network and immediately access it, and its ports, without any reconfiguration of the containers already on the network.



