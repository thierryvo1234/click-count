# Scalable: increasing throughput: Deploying the containerized web application

We are going to package the web application in a Docker container image, and run that container image on the Kubernetes cluster as a load-balancer set of replicas that can scale to the needs of our users.

# Objective
To package and deploy our application on Kubernetes cluster, we must:
1. Package the application the app in Docker image
2. Run the container locally on our machine
3. Upload the image to the registry
4. Create a container cluster
5. Deploy our app to the cluster
6. Expose our app to the Internet
7. Scale up our deployment
8. Deploy a new version of our app


## 1. Package the application the app in Docker image

To build a Docker image, you need to have an application and a Dockerfile.
The application is packaged as a Docker image, using the Dockerfile that contains instructions on how the image is built. 

We did it in the section
- => [Jenkins](docs/continuous_integration.md)
- => [Docker, for front-end](docs/docker_front-end.md)


## 2. Run the container locally on our machine

We can run the container locally if we want to
for testing

```console
docker run --name web-app -p 8080:8080 -d --link=redis thierrylamvo/web-app
```

## 3. Upload the container image to the registry

Docker Hub is the place where open Docker images are stored.

Log into the Docker Hub from the command line
```console
docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username (thierrylamvo): 
```

Push your image to the repository you created
```console
docker push thierrylamvo/web-app
```


## 4. Create a container cluster

Our cluster consists of a pool of VM instances running Kubernetes, the open source cluster orchestration system. 
Once you have created the Kubernetes cluster, you let Kubernetes manage the applications’ lifecycle.

We do this in this section:
  - => [Kubernetes: Installation for Resilience: auto-healing containers, no failover ](docs/replication.md)


## 5. Deploy our app to the cluster with Kubernetes pods

To communicate with the Kubernetes cluster, you typically do this by using the kubectl command-line tool.

Kubernetes represents applications as Pods, which are units that represent a container (or group of tightly-coupled containers). 

The kubectl run command below causes Kubernetes to create a Deployment named web-app on your cluster. The Deployment manages multiple copies of your application, called replicas, and schedules them to run on the individual nodes in your cluster. In this case, the Deployment will be running only one Pod of your application.

> A possible approach, but not recommanded way to deploy our application, listening on port 8080 is to launch this command:
> ```console
> kubectl run web-app --image=thierrylamvo/web-app --port 8080
> ```

However, a better approach is to Edit pod-web-app.yml :
```consoleapiVersion: v1
kind: Pod
apiVersion: v1
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  containers:
    - image: thierrylamvo/web-app
      name: web-app
      ports:
      - containerPort: 80
      imagePullPolicy: Always
```

To see the Pod created by the Deployment, run the following command:
```console
kubectl get pods
```
Then launch the command as a root user:
```console
kubectl create -f pod-web-app.yml
```

Check the pod is launching by:
```console
kubectl get pods
```

Output
```console
NAME                           READY     STATUS    RESTARTS   AGE
web-app                        1/1       Running   0          23s
```


## 6. Expose our app to the Internet with Kubernetes services

By default, the containers you run are not accessible from the Internet, because they do not have external IP addresses. You must explicitly expose your application to traffic from the Internet

> A possible approach, but not recommanded way to expose your application to traffic from the Internet, listening on port 8080 is to launch this command:
> ```console
> kubectl expose deployment web-app --type=LoadBalancer --port 80 --target-port 8080
> ```
> The kubectl expose command above creates a Service resource, which provides networking and IP support to your application's Pods. If you were on a cloud such as AWS, GKE, it will create an external IP and a Load Balancer (subject to billing) for your application.
> The --port flag specifies the port number configured on the Load Balancer, and the --target-port flag specifies the port number that is used by the Pod created by the kubectl run command from the previous step.


However, a better approach is to Edit service-web-app.yml :
```console
apiVersion: v1
kind: Service
metadata:
  name: web-app
spec:
  selector:
    app: web-app
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
    nodePort: 30808
  type: NodePort
```

Keep in mind that NodePort must be set to a number in the flag-configured range 30000-32767. Otherwise, kubernetes throws an error. This NodePort range can be changed using the flag --service-node-port-range passed to kube-apiserver per https://kubernetes.io/docs/reference/generated/kube-apiserver/:


Then launch the command as a root user, :
```console
kubectl create -f service-web-app.yml
```

Check the pod is launching by:
```console
kubectl get services
```

Output
```console
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
web-app        NodePort    10.109.242.242   <none>        8080:30808/TCP   22m
```

Usually, on a cloud, EXTERNAL-IP will be generated automatically. Since we're on local VM, we will need to do some extra tasks to expose to the external world.

Once you've determined the external IP address for your application, copy the IP address. Point your browser to this external IP URL (eg. http://203.0.113.0) to see that your application will be accessible.



## 7. Scale up our deployment with Kubernetes deployment

To manage the increasing throughput on our web-app service, we need to scale up.
In the opposite, to reduce the cost because of decreasing throughput on our web-app service, we need to scale down.

Thus, now, we are going to learn how to scale up, by adding more replicas to our web-app's deployment resource by using the kubectl scale command. To add two additional replicas to your Deployment (for a total of three), run the following command:

> A possible approach, but not recommanded way to scale up our application is to launch this command:
> ```console
> kubectl scale deployment web-app --replicas=3
> ```

However, a better approach is to Edit deployment-web-app.yml :
```console
apiVersion: apps/v1
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

Be careful, make sure to change the hostAliases accordingly. (eg. in AWS, the ip will be: "")
We especially added those lines
which will append the /etc/hosts on each pod
to map the redis server ip with the ip 10.211.55.4, which is fixed.
```console
      hostAliases:
      - ip: "10.211.55.4"
        hostnames:
        - "redis"
```




Then launch the command as a root user:
```console
kubectl create -f deployment-web-app.yml
```

Check the pod is launching by:
```console
NAME          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
web-app       2         2         2            2           36s
```

Now, you can check that your app is well deployed on the other nodes of the Kubernetes cluster:
```console
kubectl get pods   # allows us to check the pods running
```

Output
```console
NAME                           READY     STATUS    RESTARTS   AGE
web-app-64d996d646-5nbqz       1/1       Running   0          4m
web-app-64d996d646-ndnnw       1/1       Running   0          4m
```

To check the IP address of the nodes where the pods were deployed:
```console
kubectl describe pods web-app-64d996d646-5nbqz
```

OUTPUT
```console
Name:               web-app-64d996d646-5nbqz
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               centos-linux-slave-1.shared/10.211.55.5
Start Time:         Sun, 09 Dec 2018 16:36:16 +0100
Labels:             app=web-app
                    pod-template-hash=2085528202
Annotations:        <none>
Status:             Running
IP:                 10.244.1.55
Controlled By:      ReplicaSet/web-app-64d996d646
Containers:
  web-app:
    Container ID:   docker://05c2463f2192fc54999198179d040d6b9d948d314d31ef205c686bd264115777
    Image:          thierrylamvo/web-app
    Image ID:       docker-pullable://docker.io/thierrylamvo/web-app@sha256:56c508daa62fdf12d728fe6d78c6f1730ddce10ead06284acbeb867ddca6759c
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sun, 09 Dec 2018 16:36:19 +0100
    Ready:          True
    Restart Count:  0
    Environment:    <none>
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
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                                  Message
  ----    ------     ----  ----                                  -------
  Normal  Scheduled  6m    default-scheduler                     Successfully assigned default/web-app-64d996d646-5nbqz to centos-linux-slave-1.shared
  Normal  Pulling    6m    kubelet, centos-linux-slave-1.shared  pulling image "thierrylamvo/web-app"
  Normal  Pulled     6m    kubelet, centos-linux-slave-1.shared  Successfully pulled image "thierrylamvo/web-app"
  Normal  Created    6m    kubelet, centos-linux-slave-1.shared  Created container
  Normal  Started    6m    kubelet, centos-linux-slave-1.shared  Started container
```

To check the IP address of the second node where the pods where deployed;
```console
kubectl describe pods web-app-64d996d646-ndnnw
```

OUTPUT
```console
Name:               web-app-64d996d646-ndnnw
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               centos-linux-slave-2.shared/10.211.55.6
Start Time:         Sun, 09 Dec 2018 16:36:16 +0100
Labels:             app=web-app
                    pod-template-hash=2085528202
Annotations:        <none>
Status:             Running
IP:                 10.244.2.38
Controlled By:      ReplicaSet/web-app-64d996d646
Containers:
  web-app:
    Container ID:   docker://35c67ac9b152f44268575996868b152de87ba2444efc3e77e2a40d75e41a9b4f
    Image:          thierrylamvo/web-app
    Image ID:       docker-pullable://docker.io/thierrylamvo/web-app@sha256:56c508daa62fdf12d728fe6d78c6f1730ddce10ead06284acbeb867ddca6759c
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sun, 09 Dec 2018 16:36:19 +0100
    Ready:          True
    Restart Count:  0
    Environment:    <none>
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
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                                  Message
  ----    ------     ----  ----                                  -------
  Normal  Scheduled  9m    default-scheduler                     Successfully assigned default/web-app-64d996d646-ndnnw to centos-linux-slave-2.shared
  Normal  Pulling    9m    kubelet, centos-linux-slave-2.shared  pulling image "thierrylamvo/web-app"
  Normal  Pulled     9m    kubelet, centos-linux-slave-2.shared  Successfully pulled image "thierrylamvo/web-app"
  Normal  Created    9m    kubelet, centos-linux-slave-2.shared  Created container
  Normal  Started    9m    kubelet, centos-linux-slave-2.shared  Started container
```

As you can see based on the described from the output above,
our pods where well distributed equally on the slave nodes of Kubernetes cluster.

To check also,
you can open your browser at the address:

- either http://10.211.55.6:30808/clickCount/ (slave node 1)
- or either http://10.211.55.7:30808/clickCount/ (slave node 2)

It works.


# Load Balancing
If you go the url of one of the slave nodes,
for example, 10.211.55.5:32334,
you will see that you are able to use the service


## 8. Deploy a new version of our app

Kubernetes's rolling update mechanism ensures that your application remains up and available even as the system replaces instances of your old container image with your new one across all the running replicas.

You can create an image for the v2 version of your application by building the same source code and tagging it as v2.
```console
docker build -t thierrylamvo/web-app:v2 .
```
Then push the image to the Google Container Registry:

```console
docker push thierrylamvo/web-app:v2
```
Now, apply a rolling update to the existing deployment with an image update:
```console
kubectl set image deployment web-app web-app=thierrylamvo/web-app:v2
```

Visit your application again at http://[EXTERNAL_IP], or  http://[ONE OF THE SLAVE IP:30808] 
and observe the changes you made take effect.


## 9. Cleaning up

To avoid incurring unwanted charges to your Kubernetes cluster for the resources unused:

Delete the Service: This step will deallocate the Cloud Load Balancer created for your Service:
```console
kubectl delete service web-app
```

Delete the pods:
```console
kubectl delete pods web-app
```

Delete the deployment:
```console
kubectl delete deployment web-app
```


