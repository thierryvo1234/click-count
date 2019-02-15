# Map the Redis IP to HAProxy IP, which is going to forward the incoming traffic

The basic configuration in the /etc/hosts in a docker instance of a pod:
would look like this:
<img src="/images/etc_hosts_in_pods.png" width="50%">



Since we need that this docker instance to communicate with the redis server,
we will map the redis server ip with the HAProxy ip, which will forward the traffic to the master od the redis cluster.

So, ideally, we would append this to the /etc/hosts in a docker instance of a pod:
```console
redis 10.211.55.4
```
where 10.211.55.4 is the HAProxy IP.

However, a better approach to automate is to edit the deployment file of Kubernetes, deployment-web-app.yml :
```console
apiVersion: v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      hostAliases:
      - ip: "10.211.55.4"
        hostnames:
        - "redis"
      containers:
        - image: thierrylamvo/web-app
          name: web-app
          ports:
          - containerPort: 80
          imagePullPolicy: Always
```
          
We especially added those lines which will append the /etc/hosts on each pod to map the redis server ip with the ip 10.211.55.4, which is fixed.
```console
      hostAliases:
      - ip: "10.211.55.4"
        hostnames:
        - "redis"
```

# The Output


Having brought the HAProxy, we can reach our web-app from:
- The ha proxy: http://10.211.55.4:8080/clickCount
- the slave node 1: http://10.211.55.5:30808/clickCount/
- the slave node 2: http://10.211.55.6:30808/clickCount/


From the HAProxy, our web-app interacts with the Redis Database:
![web_app_from_HAProxy](/images/web_app_10_211_55_4.png)

From the slave node 1, our web-app interacts with the Redis Database:
![web_app_from_slave1](/images/web_app_10_211_55_5.png)

From the slave node 2, our web-app interacts with the Redis Database:
![web_app_from_slave2](/images/web_app_10_211_55_6.png)

