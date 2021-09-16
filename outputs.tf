output "address" {
  description = "RDS database address"
  value       = aws_db_instance.this.address
}

output "instance_connection_info" {
  description = "Object containing connection info"
  value = {
    address  = aws_db_instance.this.address
    endpoint = aws_db_instance.this.endpoint
    id       = aws_db_instance.this.id
    port     = aws_db_instance.this.port
    username = aws_db_instance.this.username
  }
}

output "instance_id" {
  description = "Instance ID of RDS DB"
  value       = aws_db_instance.this.id
}
