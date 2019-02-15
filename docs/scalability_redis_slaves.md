# Start up the Redis Slaves

Although the Redis master is a single pod,
you can make it highly available to meet traffic demands and failovers 
by adding replica Redis slaves.


Edit deployment-redis-slaves.yml:
```console
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: redis-slave
  labels:
    app: redis
spec:
  selector:
    matchLabels:
      app: redis
      role: slave
      tier: backend
  replicas: 2
  template:
    metadata:
      labels:
        app: redis
        role: slave
        tier: backend
    spec:
      containers:
      - name: slave
        image: gcr.io/google_samples/gb-redisslave:v1
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        env:
        - name: GET_HOSTS_FROM
          # value: dns
          # Using `GET_HOSTS_FROM=dns` requires your cluster to
          # provide a dns service. As of Kubernetes 1.3, DNS is a built-in
          # service launched automatically. However, if the cluster you are using
          # does not have a built-in DNS service, you can instead
          # access an environment variable to find the master
          # service's host. To do so, comment out the 'value: dns' line above, and
          # uncomment the line below:
          # value: env
          value: redis
        ports:
        - containerPort: 6379
```

Apply the Redis Slave Deployment from the deployment-redis-slaves.yml file:
```console
kubectl apply -f deployment-redis-slaves.yml
```

Query the list of Pods to verify that the Redis Slave Pods are running:
```console
kubectl get pods
```

Output:
```console
NAME                        READY STATUS     RESTARTS   AGE
redis-slave-75856fbd-87zl4	1/1	  Running    0          2m
redis-slave-75856fbd-z69c5	1/1	  Running    0          2m

```

Let's describe the redis slave pod, named redis-slave-75856fbd-7jn77:
```console
kubectl describe pods redis-slave-75856fbd-z69c5
```

# Creating the Redis Slave Service

The guestbook application needs to communicate to Redis slaves to read data. To make the Redis slaves discoverable, you need to set up a Service. A Service provides transparent load balancing to a set of Pods.

Edit service-redis-slaves.yml:
```console
apiVersion: v1
kind: Service
metadata:
  name: redis-slave
  labels:
    app: redis
    role: slave
    tier: backend
spec:
  ports:
  - port: 6379
  selector:
    app: redis
    role: slave
    tier: backend
```

Apply the Redis Slave Service from the following service-redis-slaves.yml file:
```console
kubectl apply -f service-redis-slaves.yml
```

Query the list of Services to verify that the Redis slave service is running:
```console
kubectl get services
```


