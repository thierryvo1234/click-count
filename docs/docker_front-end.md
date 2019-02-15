# DOCKER IN FRONT-END

## DOCKER BUILD

To build a new docker image using a dockerfile in the current repository:
```console
docker build --no-cache -t thierrylamvo/web-app .
```

## DOCKER RUN

To have a runnable image with -p to specify the port mapping between the port of my host and the port inside my container, -d for a detached mode
and allowing network communication with redis container is:
```console
docker run --name web-app -p 8080:8080 -d --link=redis thierrylamvo/web-app
```

In case, you got a warning message after the "docker run" command likes:
```console
WARNING: IPv4 forwarding is disabled. Networking will not work.
```
You must edit /etc/sysctl.d/enable-ip-forward.conf:
```console
net.ipv4.ip_forward=1
```
Then restart the network service:
```console
sudo systemctl restart network
```
