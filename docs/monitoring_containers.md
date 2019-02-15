# onitor containers of our Kubernetes Cluster

There are different tools that helps us to monitor containers of our Kubernetes cluster:
- ELK = Elastic Logstash Kibana
- Prometheus
- DataDog

Thanks to Kubernetes, you can take advantage of DaemonSets to automatically deploy the Datadog Agent on all your nodes.

A DaemonSet ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected. Deleting a DaemonSet will clean up the Pods it created.

Some typical uses of a DaemonSet are:
- running a cluster storage daemon, such as glusterd, ceph, on each node.
- running a logs collection daemon on every node, such as fluentd or logstash.
- running a node monitoring daemon on every node, such as Prometheus Node Exporter, collectd, Dynatrace OneAgent, Datadog agent, New Relic agent, Ganglia gmond or Instana agent.

Once the DaemonSets extension is enabled, create a manifest daemonSet-datadog-agent.yml using the following manifest to deploy the Datadog Agent.
```console
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: datadog-agent
spec:
  template:
    metadata:
      labels:
        app: datadog-agent
      name: datadog-agent
    spec:
      containers:
      - image: datadog/agent:latest
        imagePullPolicy: Always
        name: datadog-agent
        ports:
          - containerPort: 8125
            name: dogstatsdport
            protocol: UDP
          - containerPort: 8126
            name: traceport
            protocol: TCP
        env:
          - name: DD_API_KEY
            value: 4929140ae5df339bd9b94xxxxxxxxxxx
          - name: KUBERNETES
            value: "true"
          - name: DD_KUBERNETES_KUBELET_HOST
            valueFrom:
              fieldRef:
                fieldPath: status.hostIP
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        volumeMounts:
          - name: dockersocket
            mountPath: /var/run/docker.sock
          - name: procdir
            mountPath: /host/proc
            readOnly: true
          - name: cgroups
            mountPath: /host/sys/fs/cgroup
            readOnly: true
        livenessProbe:
          exec:
            command:
            - ./probe.sh
          initialDelaySeconds: 15
          periodSeconds: 5
      volumes:
        - hostPath:
            path: /var/run/docker.sock
          name: dockersocket
        - hostPath:
            path: /proc
          name: procdir
        - hostPath:
            path: /sys/fs/cgroup
          name: cgroups
```      
    
Launch:
```console
kubectl create -f daemonSet-datadog-agent.yml
```
