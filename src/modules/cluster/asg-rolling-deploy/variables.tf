
variable "cluster_name" {
  description = "the name to use for all the cluster resources"
  type =   string
}

variable "instance_type" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "custom_tags" {
	description = "values to be added to the tags"
	type = map(string)
	default = {}
}

variable "enable_autoscaling" {
	default = false
  type = bool
}

variable "server_port" {
  description = "Port to use for the instance"
  type        = number
  default     = 8080
}

variable "subnet_ids" {
  description = "Subnet IDs to use for the instance"
  type        = list(string)
}

variable "target_group_arns" {
  description = "Target group ARNs to use for the instance"
  type        = list(string)
  default = []
}

variable "health_check_type" {
  description = "Health check type to use for the instance. Must be one of 'EC2' or 'ELB'"
  type        = string
  default     = "EC2"
}

variable "user_data" {
  description = "User data to use for the instance"
  type        = string
  # default     = null
  
}