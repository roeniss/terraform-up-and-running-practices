output "alb_dns_name" {
  value       = module.webserver_cluster.alb_domain
  description = "The DNS name of the ALB"
}