provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

locals {
  required_tags = {
    Owner       = var.owner,
    Environment = var.environment,
    Costcenter  = var.costcenter,
    Terraform   = "True"
  }
  region_map = {
    "us-east-1" = "ue1",
    "us-east-2" = "ue2",
    "us-west-1" = "uw1",
    "us-west-2" = "uw2"
  }
  region           = local.region_map[data.aws_region.current.name]
  project_name     = "aws${var.environment}${var.app_name}-${local.region}"
  msk_cluster_name = upper("${local.project_name}-msk")
}

resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = upper("${local.project_name}-msk")
  tags                   = merge({ Name = "${local.project_name}-msk" }, local.required_tags, var.additional_tags)
  kafka_version          = "2.6.1"
  number_of_broker_nodes = 2

  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
    encryption_in_transit {
      client_broker = var.encryption_in_transit_client_broker
      in_cluster    = var.encryption_in_transit_in_cluster
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.SGDEFAULTMSK.arn
    revision = aws_msk_configuration.SGDEFAULTMSK.latest_revision
  }

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    ebs_volume_size = 100
    client_subnets  = var.msk_subnet_ids
    security_groups = var.msk_security_group_ids
  }

}

resource "aws_msk_configuration" "SGDEFAULTMSK" {
  kafka_versions = ["2.6.1"]
  name           = "SG"

  server_properties = <<PROPERTIES
  auto.create.topics.enable=true
  default.replication.factor=2
  min.insync.replicas=2
  num.io.threads=8
  num.network.threads=5
  num.partitions=2
  num.replica.fetchers=2
  replica.lag.time.max.ms=30000
  socket.receive.buffer.bytes=102400
  socket.request.max.bytes=104857600
  socket.send.buffer.bytes=102400
  unclean.leader.election.enable=true
  zookeeper.session.timeout.ms=18000
PROPERTIES
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster."
  value       = aws_msk_cluster.msk_cluster.zookeeper_connect_string
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs."
  value       = aws_msk_cluster.msk_cluster.bootstrap_brokers_tls
}
