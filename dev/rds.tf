/*
data "aws_rds_engine_version" "aurora_mysql" {
  engine = "aurora-mysql"
  latest = true

  filter {
    name = "db-parameter-group-family"

    values = [
      "aurora-mysql8.0"
    ]
  }
}

locals {
  aurora_engine_version = (
    var.aurora_engine_version_mode == "fixed"
    ? var.aurora_engine_version
    : data.aws_rds_engine_version.aurora_mysql.version_actual
  )
}

resource "aws_db_subnet_group" "aurora_mysql" {
  name        = "${local.provider}-dbsng-${local.project}-${local.environment}-${local.region_code}-aurora01"
  description = "DB subnet group for Aurora MySQL"

  subnet_ids = [
    aws_subnet.db[0].id,
    aws_subnet.db[1].id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-dbsng-${local.project}-${local.environment}-${local.region_code}-aurora01"
    }
  )
}

resource "aws_rds_cluster_parameter_group" "aurora_mysql" {
  name        = "${local.provider}-dbpg-${local.project}-${local.environment}-${local.region_code}-aurora-mysql-cluster01"
  family      = "aurora-mysql8.0"
  description = "Cluster parameter group for Aurora MySQL"

  parameter {
    name         = "time_zone"
    value        = "Asia/Seoul"
    apply_method = "immediate"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-dbpg-${local.project}-${local.environment}-${local.region_code}-aurora-mysql-cluster01"
    }
  )
}

resource "aws_db_parameter_group" "aurora_mysql" {
  name        = "${local.provider}-dbpg-${local.project}-${local.environment}-${local.region_code}-aurora-mysql-instance01"
  family      = "aurora-mysql8.0"
  description = "DB parameter group for Aurora MySQL instances"
}

# ============================================================
# RDS Option Group
# - Used by standard RDS engines such as MySQL
# - Not used by Aurora MySQL
# - Created for Terraform / RDS Option Group practice only
# ============================================================

resource "aws_db_option_group" "mysql" {
  name                     = "${local.provider}-dbog-${local.project}-${local.environment}-${local.region_code}-mysql01"
  option_group_description = "Option group for standard RDS MySQL practice"

  engine_name          = "mysql"
  major_engine_version = "8.0"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.provider}-dbog-${local.project}-${local.environment}-${local.region_code}-mysql01"
    }
  )
}

resource "aws_rds_cluster" "aurora_mysql" {
  cluster_identifier = var.aurora_cluster_identifier

  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = local.aurora_engine_version

  master_username = var.aurora_master_username
  manage_master_user_password = var.aurora_manage_master_user_password

  iam_database_authentication_enabled = var.aurora_iam_database_authentication_enabled

  db_subnet_group_name = aws_db_subnet_group.aurora_mysql.name

  vpc_security_group_ids = [
    aws_security_group.aurora_mysql.id
  ]

  port = var.aurora_mysql_port

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql.name

  backup_retention_period = var.aurora_backup_retention_period

  copy_tags_to_snapshot = var.aurora_copy_tags_to_snapshot

  storage_encrypted = var.aurora_storage_encrypted

  enabled_cloudwatch_logs_exports = var.aurora_cloudwatch_log_exports

  apply_immediately = var.aurora_apply_immediately

  deletion_protection = var.aurora_deletion_protection
  skip_final_snapshot = var.aurora_skip_final_snapshot

  tags = merge(
    local.common_tags,
    {
      Name = var.aurora_cluster_identifier
    }
  )
}

# ============================================================
# Aurora MySQL Writer
# ============================================================

resource "aws_rds_cluster_instance" "aurora_writer" {
  identifier         = "${var.aurora_cluster_identifier}-writer01"
  cluster_identifier = aws_rds_cluster.aurora_mysql.id

  instance_class = var.aurora_instance_class

  engine         = aws_rds_cluster.aurora_mysql.engine
  engine_version = aws_rds_cluster.aurora_mysql.engine_version

  db_parameter_group_name = aws_db_parameter_group.aurora_mysql.name

  publicly_accessible = false

  auto_minor_version_upgrade = var.aurora_auto_minor_version_upgrade
  apply_immediately          = var.aurora_apply_immediately

  tags = merge(
    local.common_tags,
    {
      Name = "${var.aurora_cluster_identifier}-writer01"
    }
  )
}

# ============================================================
# Aurora MySQL Reader
# - Default replica count: 0
# ============================================================

resource "aws_rds_cluster_instance" "aurora_reader" {
  count = var.aurora_replica_count

  identifier         = "${var.aurora_cluster_identifier}-reader0${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_mysql.id

  instance_class = var.aurora_instance_class

  engine         = aws_rds_cluster.aurora_mysql.engine
  engine_version = aws_rds_cluster.aurora_mysql.engine_version

  db_parameter_group_name = aws_db_parameter_group.aurora_mysql.name

  publicly_accessible = false

  auto_minor_version_upgrade = var.aurora_auto_minor_version_upgrade
  apply_immediately          = var.aurora_apply_immediately

  tags = merge(
    local.common_tags,
    {
      Name = "${var.aurora_cluster_identifier}-reader0${count.index + 1}"
    }
  )
}
*/