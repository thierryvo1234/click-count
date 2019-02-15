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
