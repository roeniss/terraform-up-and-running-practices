output "address" {
  value       = aws_db_instance.example-stage.address
  description = "The address of the RDS instance"
}

output "port" {
  value       = aws_db_instance.example-stage.port
  description = "The port of the RDS instance"
}
