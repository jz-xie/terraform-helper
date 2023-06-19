terraform {
  required_providers {
    aws = {
      version = ">=4.59.0"
    }
  }
}

locals {
  rds_engine_major_version = split(".", data.aws_rds_engine_version.postgresql.version)[0]
}

module "aurora_postgresql_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.7.0"

  name           = "${var.app}-${var.environment}"
  engine         = data.aws_rds_engine_version.postgresql.engine
  engine_mode    = "provisioned"
  engine_version = data.aws_rds_engine_version.postgresql.version
  serverlessv2_scaling_configuration = {
    max_capacity = 128.0
    min_capacity = 0.5
  }
  instance_class    = "db.serverless"
  instances         = var.instances
  storage_encrypted = true

  create_db_subnet_group = false
  db_subnet_group_name   = var.db_subnet_group_name

  create_security_group  = false
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = var.publicly_accessible
  database_name          = var.app
  create_random_password = false
  master_username        = var.app
  master_password        = var.rds_master_passwored
  apply_immediately      = true

  db_parameter_group_name         = aws_db_parameter_group.postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql.id

  tags = {
    project     = var.app
    environment = var.environment
  }
}

resource "aws_db_parameter_group" "postgresql" {
  name        = "${var.app}-${var.environment}-parameter-group"
  family      = "aurora-postgresql${local.rds_engine_major_version}"
  description = "${var.app}-${var.environment}-parameter-group"
  tags = {
    project     = var.app
    environment = var.environment
  }
}

resource "aws_rds_cluster_parameter_group" "postgresql" {
  name        = "${var.app}-${var.environment}-cluster-parameter-group"
  family      = "aurora-postgresql${local.rds_engine_major_version}"
  description = "${var.app}-${var.environment}-cluster-parameter-group"
  tags = {
    project     = var.app
    environment = var.environment
  }
}
