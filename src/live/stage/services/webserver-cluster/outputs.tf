output "subnet_ids" {
  value       = module.webserver_cluster.subnet_ids
  description = "Subnet IDs"
}

output "alb_domain" {
  value       = module.webserver_cluster.alb_domain
  description = "ALB DNS name"
}

output "rds_address" {
  value       = module.webserver_cluster.rds_address
  description = "address of the RDS instance"
}

output "rds_port" {
  value       = module.webserver_cluster.rds_port
  description = "port of the RDS instance"
}


