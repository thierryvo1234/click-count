# Deploy Redis cluster architecture on the AWS cloud for the back-end
# Through AWS_elasticache_cluster Redis Terraform module

## 1. Let's choose the Redis architecture on AWS

There are 2 types of replication Redis arhitecture. Let's summarize the differences:
- cluster mode disabled. This cluster always has a single shard (API/CLI: node group) with up to 5 read replica nodes
- cluster mode enabled. This cluster has up to 90 shards with 1 to 5 read replica nodes in each.


![cluster_mode_disabled](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/images/ElastiCache-NodeGroups.png)

Feature |	Redis (cluster mode disabled)|	Redis (cluster mode enabled)
--- | --- | ---
Modifiable |	Yes. Supports adding and deleting replica nodes, and scaling up node type.	| Limited. For more information, see Upgrading Engine Versions and Scaling Redis (cluster mode enabled) Clusters.
Data Partitioning	| No |	Yes
Shards |	1	| 1 to 90
Read replicas	| 0 to 5. Important. If you have no replicas and the node fails, you experience total data loss. | 0 to 5 per shard. Important. If you have no replicas and a node fails, you experience loss of all data in that shard.
Multi-AZ with Automatic Failover |	Yes, with at least 1 replica. Optional. On by default. | Yes. Required.
Snapshots (Backups)	| Yes, creating a single .rdb file.	| Yes, creating a unique .rdb file for each shard.
Restore	| Yes, using a single .rdb file from a Redis (cluster mode disabled) cluster. |	Yes, using .rdb files from either a Redis (cluster mode disabled) or a Redis (cluster mode enabled) cluster.


## 2. Based on our use case of click-count Web application, we choose the Redis cluster mode disabled Architecture as the most appropriate.

The "Redis cluster mode disabled" is not easier or more complicated to configure compare to "Redis cluster mode enabled", it just more appropriate for our click-count application Web use-case.


To create Redis Cluster Mode Disabled, a single shard primary with 2 read replica, edit instance_private.tf:
```console
resource "aws_elasticache_replication_group" "rg_redis"  {
  automatic_failover_enabled = true
  availability_zones = ["${var.region}a","${var.region}b","${var.region}c"]
  replication_group_id = "rg-redis"
  replication_group_description = "replication_group for redis which is configured with a single shard primary with 2 read replicas"
  node_type = "cache.t2.micro"
  number_cache_clusters = 3
  parameter_group_name = "default.redis5.0"
  port = 6379
  subnet_group_name = "${aws_elasticache_subnet_group.sg-elasticache-redis.name}"
  security_group_ids = ["${aws_security_group.sg_WebApps_to_Redis_database.id}"]

  depends_on = ["aws_subnet.private-a","aws_subnet.private-b","aws_subnet.private-c"]

```

The following arguments are used:
- number_cache_clusters - (Required for Cluster Mode Disabled) The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications.
- replication_group_id – (Required) The replication group identifier. This parameter is stored as a lowercase string.
- replication_group_description – (Required) A user-created description for the replication group.
- node_type - (Required) The compute and memory capacity of the nodes in the node group.
- automatic_failover_enabled - (Optional) Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false.

- availability_zones - (Optional) A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important.
- engine - (Optional) The name of the cache engine to be used for the clusters in this replication group. e.g. redis
- parameter_group_name - (Optional) The name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used.
- port – (Optional) The port number on which each of the cache nodes will accept connections. For Memcache the default is 11211, and for Redis the default port is 6379.
- subnet_group_name - (Optional) The name of the cache subnet group to be used for the replication group.
- security_group_names - (Optional) A list of cache security group names to associate with this replication group.
- security_group_ids - (Optional) One or more Amazon VPC security groups associated with this replication group. Use this parameter only when you are creating a replication group in an Amazon Virtual Private Cloud
- cluster_mode - (Optional) Create a native redis cluster. automatic_failover_enabled must be set to true. Cluster Mode documented below. Only 1 cluster_mode block is allowed.


You can configure multiple instances of Redis Web Cache to run as independent caches, with no interaction with one another. However, to increase the availability and scalability of your cache, you can configure multiple instances of Redis to run as members of a cache cluster. A cache cluster is a loosely coupled collection of cooperating Redis cache instances working together to provide a single logical cache. A cache cluster can consist of two or more members. The cache cluster members communicate with one another to request cacheable content that is cached by another cache cluster member and to detect when a cache cluster member fails.


## 3. Benefits of Cache Clusters: 
It provide the following benefits:

### - High availability:

With cache clusters,  Web Cache supports failure detection and failover of caches. If a Web cache fails, other members of the cache cluster detect the failure and take over ownership of the cacheable content of the failed cluster member.

### - Scalability and performance:

By distributing the site's content across multiple caches, more content can be cached and more client connections can be supported, expanding the capacity of your Web site.

By deploying multiples caches in a cache cluster, you make use of the processing power of more CPUs. Because multiple requests are executed in parallel, you increase the number of requests that are served concurrently.

Network bottlenecks often limit the number of requests that can be processed at one time. Even on a node with multiple network cards, you can encounter operating system limitations. By deploying caches on separate nodes, more network bandwidth is available. Response time is improved because of the distribution of requests.

In a cache cluster, fewer requests are routed to the application Web server. Retrieving content from a cache (even if that request is routed to another cache in the cluster) is more efficient than materializing the content from the application Web server.

### - Reduced load on the application Web server:

In a cache cluster environment, popular objects are stored in more than one cache. If a cache fails, requested cacheable objects are likely to be stored in the cache of surviving cluster members. As a result, fewer requests for cacheable objects need to be routed to the application Web server even when a cache fails.

When a failed cache returns to operation, it has no objects cached. In a non-cluster environment with multiple independent caches, that cache must route cache misses to the application Web server. In a cache cluster environment, that cache can route cache misses to other caches in the cluster, reducing the load on the application Web server.

Cache clusters maximize system resource utilization. When each cache in a cache cluster resides on a separate node, more memory is available than for one cache on a single node. With more memory, Web App Cache can cache more content, resulting in fewer requests to the application Web server.

### - Improved data consistency:

Because Web App Cache uses one set of invalidation rules for all cache cluster members and because it makes it easy to propagate invalidation requests to all cache cluster members, the cached data is more likely to be consistent across all caches in a cluster.

You can configure a cache cluster that does not support requests between cache cluster members, but allows propagating invalidation requests, as well as propagating configuration changes. See "Configuring Administration and Invalidation-Only Clusters" for more information.

### - Manageability:

Cache clusters are easy to manage because they use one configuration for all cache cluster members. For example, you specify one set of caching rules and one set of invalidation rules. Web App Cache distributes those rules throughout the cluster by propagating the configuration to each cluster member.


# How Cache Clusters Works
In a cache cluster, multiple instances of Web Cache App operate as one logical cache.

A cache cluster uses one configuration that is propagated to all cluster members. The configuration contains general information, such as security, session information, and caching rules, which is the same for all cluster members. It also contains cache-specific information, such as capacity, administration, and other ports, resource limits, and log files, for each cluster member.

Each member must be authenticated before it is added to the cache cluster. The authentication requires that the administration username and password of the Web App Cache instance which are added, be the same as the administration username and password of the cluster.

When you add a cache to the cluster, the cache-specific information of the new cluster member is added to the configuration of the cache cluster. Then, Web App Cache propagates the configuration to all members of the cluster. Because adding a new member changes the relative capacity of each Web cache, Web App Cache uses the information about capacity to recalculate which cluster member owns which content.

When cache cluster members detect the failure of another cluster member, the remaining cache cluster members automatically take over ownership of the content of the failing member. When the cache cluster member is reachable again, Web App Cache again reassigns the ownership of the content.

When you remove a Web cache from a cache cluster, the remaining cache cluster members take over ownership of the content of the removed member. In addition, the configuration information about the removed member is deleted from the configuration and the revised configuration is propagated to the remaining cache cluster members.

In a cache cluster, administrators can decide whether to propagate invalidation messages to all cache cluster members or to send invalidation messages individually to cache cluster members.


# On AWS WEB UI CONSOLE

After:
```console
terraform apply
```

On AWS WEB UI CONSOLE:
ElastiCache Dashboard/Redis:


Cluster Name | Mode | Shards | Nodes | Node Type | Status | Encryption in-transit | Encryption at-rest
--- | --- | --- | --- | --- | --- | --- | ---
rg-redis | Redis | 1 | 3 nodes | cache.m5.xlarge | available | No | No


On description:
- Name: The identifier for the cluster	rg-redis
- Status: The status of this Cluster	available
- Creation Time: The time (UTC) when the cluster was created	December 30, 2018 at 10:32:13 AM UTC+1
- Configuration Endpoint: The configuration endpoint of the cluster	-
- Primary Endpoint: Primary endpoint of the cluster	rg-redis.feg1ds.ng.0001.euw3.cache.amazonaws.com:6379
- Node type: The type of the Node in your cluster	cache.m5.xlarge
- Engine: Engine on the cluster	Redis
- Engine Version Compatibility: Version compatibility of the engine that will be run on your nodes	5.0.0
- Availability Zones: The Availability Zone(s) in which you would prefer to deploy your Cluster	eu-west-3b, eu-west-3a, eu-west-3c
- Shards: The number of Shards in a Redis Cluster	1
- Number of Nodes: The number of Nodes in the cluster	3 nodes
- Notification ARN: The Amazon Resource Number (ARN) of the SNS topic for which you receive notifications related to the Cluster	Disabled
- Subnet Group: The Subnet Group of the Cluster	default
- Security Group(s): If the nodes are not in VPC, these are the names of the Security Groups. If the nodes are in a VPC, these are the IDs of the VPC security groups	
- Parameter Group: The parameter group of the Cluster	default.redis5.0 (in-sync)
- Backup Retention Period: The number of days for which automated backups are retained.	Disabled
- Backup Window: The daily time range during which automated backups are initiated if automated backups are enabled.	Disabled
- Maintenance Window: The weekly time range (in UTC) during which system maintenance can occur.	fri:03:30-fri:04:30
- Encryption in-transit: Status of enabling encryption of data on-the-wire	No
- Encryption at-rest: Status of enabling encryption for data stored on disk	No
- Redis Auth: Status of Redis Auth which is an authentication mechanism for Redis Server	No

On Nodes details:

Node Name | Status | Current Role | Port | Endpoint | Parameter Group Status | Zone | Created on
--- | --- | --- | --- | --- | --- | --- | ---
rg-redis-001 | available | primary | 6379 | rg-redis-001.feg1ds.0001.euw3.cache.amazonaws.com | in-sync | eu-west-3b | December 30, 2018 at 10:32:13 AM UTC+1
rg-redis-002 | available | replica | 6379 | rg-redis-002.feg1ds.0001.euw3.cache.amazonaws.com | in-sync | eu-west-3a | December 30, 2018 at 10:32:13 AM UTC+1
rg-redis-003 | available | replica | 6379 | rg-redis-003.feg1ds.0001.euw3.cache.amazonaws.com | in-sync | eu-west-3c | December 30, 2018 at 10:32:13 AM UTC+1


