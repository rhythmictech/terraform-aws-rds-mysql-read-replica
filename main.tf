locals {
  engine                    = "mysql"
  final_snapshot_identifier = var.final_snapshot_identifier == null ? "${var.name}-final-snapshot" : var.final_snapshot_identifier
  parameter_group_name      = length(var.parameters) > 0 ? aws_db_parameter_group.this[0].name : null
}

resource "aws_db_parameter_group" "this" {
  count = length(var.parameters) > 0 ? 1 : 0

  name_prefix = "${var.name}-param"

  family = "${local.engine}${var.engine_version}"

  dynamic "parameter" {
    iterator = each
    for_each = var.parameters

    content {
      name         = each.value.name
      apply_method = each.value.apply_method
      value        = each.value.value
    }
  }
}

resource "aws_db_instance" "this" {
  backup_retention_period             = var.backup_retention_period
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  deletion_protection                 = var.enable_deletion_protection
  enabled_cloudwatch_logs_exports     = var.cloudwatch_log_exports
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  identifier_prefix                   = var.identifier_prefix
  instance_class                      = var.instance_class
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = var.monitoring_role_arn
  multi_az                            = var.multi_az
  parameter_group_name                = local.parameter_group_name
  performance_insights_enabled        = var.performance_insights_enabled
  port                                = var.port
  replicate_source_db                 = var.replicate_source_db_id
  storage_encrypted                   = var.storage_encrypted
  storage_type                        = var.storage_type
  final_snapshot_identifier           = local.final_snapshot_identifier
  skip_final_snapshot                 = var.skip_final_snapshot

  tags = merge(var.tags,
    {
      "Name" = var.name
    }
  )
}
