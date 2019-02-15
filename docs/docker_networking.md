# Establishing the connection between Back-end end Front end

### After launching our Redis docker container

If you wish to connect to a Docker container running Redis from a remote server (or local), you can use Docker's port forwarding to access the container with the host server's IP address or domain name:
```console
docker run -p 6379:6379 --name redis -d redis
```

From the remote server (or local), you can try to use the Redis client to verify that you can communicate 
and interact with the Redis server containing in the Docker container.
```console
sudo redis-cli -h [Redis machine host IP] -p 6379
```
eg
```console
sudo redis-cli -h 192.168.0.1 -p 6379
```

### Using the redis client, redis-cli

First, grab the ip address of the redis container:
```console
docker ps  # allows us to grab the redis container id
docker inspect <container_id>    # allows us to grab the ipaddress of the redis container id
``` 
or by:
```console
docker ps  # grab the new container id
docker port <container_id> 6379  # allows us to grab the ipaddress of the redis container id
ifconfig   # allows us to grab the host of the redis container id
```

Then, launch the redis client to interact with the Redis database:
```console
redis-cli -h <ipaddress> -p 6379  # allows us to use the redis client
redis 10.0.3.32:6379> set docker awesome   # allows us to assign a key/value pair
OK
redis 10.0.3.32:6379> get docker #  # As a test, allows us to retrieve the value from the key
"awesome"
redis 10.0.3.32:6379> exit # allows us to leave the redis client
```



# Use Link network Docker connection option

Running only:
```console
docker run --name web-app -p 8080:8080 -d terryv8/web-app
```
without using the --link option, won't allow the back-end Redis container and front-end web-app container to communicate each other


So, to have a runnable image with -p to specify the port mapping between the port of my host 
and the port inside my container, -d for a detached mode and allowing network communication with redis container is:
```console
docker run --name web-app -p 8080:8080 -d --link=redis terryv8/web-app
```
