# HAProxy 

We are going to install and configure HAProxy on Centos 7.
HAProxy is a free HTTP/TCP high availability load balancer and proxy server.
It spreads requests among multiple servers to mitigate issues resulting from single server failure. 
HA Proxy is used by a number of high-profile websites including GitHub, Bitbucket, Stack Overflow, Reddit, Tumblr, Twitter and Tuenti
and is used in the OpsWorks product from Amazon Web Services.

# Types of Load Balancing

- ## No Load Balancing
A simple web application environment with no load balancing might look like the following:

![web_app_No_Load_Balancing](https://assets.digitalocean.com/articles/HAProxy/web_server.png)

In this example, the user connects directly to your web server, at yourdomain.com and there is no load balancing. If your single web server goes down, the user will no longer be able to access your web server. Additionally, if many users are trying to access your server simultaneously and it is unable to handle the load, they may have a slow experience or they may not be able to connect at all.

- ## Layer 4 Load Balancing

The simplest way to load balance network traffic to multiple servers is to use layer 4 (transport layer) load balancing. Load balancing this way will forward user traffic based on IP range and port (i.e. if a request comes in for http://yourdomain.com/anything, the traffic will be forwarded to the backend that handles all the requests for yourdomain.com on port 80). For more details on layer 4, check out the TCP subsection of our Introduction to Networking.

![web_app_Load_Balancing_type4](https://assets.digitalocean.com/articles/HAProxy/layer_4_load_balancing.png)

The user accesses the load balancer, which forwards the user's request to the web-backend group of backend servers. Whichever backend server is selected will respond directly to the user's request. Generally, all of the servers in the web-backend should be serving identical content--otherwise, the user might receive inconsistent content. Note that both web servers connect to the same database server.


# Install HAProxy 
Since we have on 3 local VMs.
Below is our network server. There are 2 web servers running our Web App and listening on port 30808 
and one HAProxy server:

- Web App Server 1:  10.211.55.5
- Web App Server 2:  10.211.55.6
- HAProxy Server:    10.211.55.4
  
Now install HAProxy with the following command:
```console
yum install haproxy
```

Modify the configuration file of haproxy, /etc/haproxy/haproxy.cfg as per our requirement
When you configure load balancing using HAProxy, there are two types of nodes which need to be defined: frontend and backend. 
The frontend is the node by which HAProxy listens for connections. Backend nodes are those by which HAProxy can forward requests. A third node type, the stats node, can be used to monitor the load balancer and the other two nodes.

Append these lines to /etc/haproxy/haproxy.cfg
```console
#---------------------------------------------------------------------
# clickCount - Homework
#---------------------------------------------------------------------

frontend haproxywebappclickcount
    bind *:8080
    mode http
    default_backend backendwebappclickcount

backend backendwebappclickcount
    balance roundrobin
    server node1 10.211.55.5:30808/clickCount check
    server node2 10.211.55.6:30808/clickCount check
```

This configures a frontend named haproxywebappclickcount, which handles all incoming traffic on port 8080.
The default_backend backendwebappclickcount specifies that all other traffic will be forwarded to backendwebappclickcount and maps to the port 30808

Now, any incoming requests to the HAProxy node at IP address 10.211.55.4 will be forwarded to an internally networked node with an IP address of either 10.211.55.5 or 10.211.55.6, also it maps port 8080 to port 30808. These backend nodes will serve the HTTP requests. If at any time either of these nodes fails the health check, they will not be used to serve any requests until they pass the test.


# High availability HAProxy

Even better,
but since we only have 3 local VMs, we don't provide here High availability of Load Balancer. However, it would be easy to do it.

The layer 4 and 7 load balancing setups described before both use a load balancer to direct traffic to one of many backend servers. However, your load balancer is a single point of failure in these setups; if it goes down or gets overwhelmed with requests, it can cause high latency or downtime for your service.

A high availability (HA) setup is an infrastructure without a single point of failure. It prevents a single server failure from being a downtime event by adding redundancy to every layer of your architecture. A load balancer facilitates redundancy for the backend layer (web/app servers), but for a true high availability setup, you need to have redundant load balancers as well.

![load_balancer_High_availability](https://assets.digitalocean.com/articles/high_availability/ha-diagram-animated.gif)


In this example, you have multiple load balancers (one active and one or more passive) behind a static IP address that can be remapped from one server to another. When a user accesses your website, the request goes through the external IP address to the active load balancer. If that load balancer fails, your failover mechanism will detect it and automatically reassign the IP address to one of the passive servers. There are a number of different ways to implement an active/passive HA setup. To learn more, read this section of How To Use Floating IPs.




