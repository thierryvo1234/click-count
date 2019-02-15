# DOCKER IN BACK-END

The basic command line to run Redis using Docker
with binding the container port to the specific port is:
```console
docker run -p 6379:6379 --name redis -d redis
```

Actually, the official Redis image contains the command EXPOSE 6379 (the default Redis port) which makes it automatically available to any linked containers. 
