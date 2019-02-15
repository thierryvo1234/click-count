

# Using Kubernetes, we decided to go for a Redis Master-Slaves architecture

There is a master and there are replicas. The master pushes data to replicas. Replicas don’t talk between themselves.
Replicas are Read-Only.

![Redis replicated architecture](https://blog.octo.com/wp-content/uploads/2017/08/screen-shot-2017-08-11-at-14-35-11.png)


- Pros:
  - You always have a hot snapshot (permanent store) of your data
  - It’s a Disaster Recovery Plan (DRP) with Master - Slave Stand-By
- Cons:
  - Write performance is bounded by the master
  - The replicas are not used as write node, only read node. 


# Step 1: Set up a Redis master

The guestbook application uses Redis to store its data. It writes its data to a Redis master instance and reads data from multiple Redis workers (slave) instances. The first step is to deploy a Redis master.

Use the manifest file named redis-master-deployment to deploy the Redis master. This manifest file specifies a Deployment controller that runs a single replica Redis master Pod:


Edit deployment-redis-master.yml:
```console
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: redis-master
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: redis
        role: master
        tier: backend
    spec:
      containers:
      - name: master
        image: k8s.gcr.io/redis:e2e  # or just image: redis
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 6379
```

Run the following command to deploy the Redis master:
```console
kubectl create -f deployment-redis-master.yml
```

Verify that the Redis master Pod is running:
```console
kubectl get pods
```

Output:
```console
redis-master-6b464554c8-7p85c   1/1       Running   0          10m
```

Let's describe the redis master pod, named redis-master-6b464554c8-7p85c:
```console
kubectl describe pods redis-master-6b464554c8-7p85c
```

Output:
```console
Name:               redis-master-6b464554c8-7p85c
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               centos-linux-slave-1.shared/10.211.55.5
Start Time:         Mon, 10 Dec 2018 14:30:58 +0100
Labels:             app=redis
                    pod-template-hash=2602011074
                    role=master
                    tier=backend
Annotations:        <none>
Status:             Running
IP:                 10.244.1.67
Controlled By:      ReplicaSet/redis-master-6b464554c8
Containers:
  master:
    Container ID:   docker://64b9e06513ade707cbcbb9f56dfdb863e37a5058fa943b4e596dcc942c4fd727
    Image:          k8s.gcr.io/redis:e2e
    Image ID:       docker-pullable://k8s.gcr.io/redis@sha256:f066bcf26497fbc55b9bf0769cb13a35c0afa2aa42e737cc46b7fb04b23a2f25
    Port:           6379/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 10 Dec 2018 14:31:43 +0100
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
      memory:     100Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-bjn4p (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-bjn4p:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-bjn4p
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                                  Message
  ----    ------     ----  ----                                  -------
  Normal  Scheduled  11m   default-scheduler                     Successfully assigned default/redis-master-6b464554c8-7p85c to centos-linux-slave-1.shared
  Normal  Pulling    11m   kubelet, centos-linux-slave-1.shared  pulling image "k8s.gcr.io/redis:e2e"
  Normal  Pulled     10m   kubelet, centos-linux-slave-1.shared  Successfully pulled image "k8s.gcr.io/redis:e2e"
  Normal  Created    10m   kubelet, centos-linux-slave-1.shared  Created container
  Normal  Started    10m   kubelet, centos-linux-slave-1.shared  Started container
```


Let's get the logs of the redis master pod, named redis-master-6b464554c8-7p85c:
```console
kubectl logs -f redis-master-6b464554c8-7p85c
```

Output:
```
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 2.8.19 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in stand alone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               
[1] 10 Dec 13:31:43.908 # Server started, Redis version 2.8.19
[1] 10 Dec 13:31:43.908 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
[1] 10 Dec 13:31:43.908 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
[1] 10 Dec 13:31:43.908 * The server is now ready to accept connections on port 6379
```


# Creating the Redis Master Service

The guestbook applications need to communicate with the Redis master to write its data. You need to apply a Service to proxy the traffic to the Redis master Pod. A Service defines a policy to access the Pods.


Edit service-redis-master.yml:
```console
apiVersion: v1
kind: Service
metadata:
  name: redis-master
  labels:
    app: redis
    role: master
    tier: backend
spec:
  ports:
  - port: 6379
    targetPort: 6379
  selector:
    app: redis
    role: master
    tier: backend
```

Apply the Redis Master Service from the following redis-master-service.yaml file:
```console
kubectl apply -f service-redis-master.yml
```

Query the list of Services to verify that the Redis Master Service is running:
```console
kubectl get service
```

Output:
```console
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
redis-master   ClusterIP   10.109.236.233   <none>        6379/TCP         18s
```

This manifest file creates a Service named redis-master with a set of labels that match the labels previously defined, so the Service routes network traffic to the Redis master Pod.

