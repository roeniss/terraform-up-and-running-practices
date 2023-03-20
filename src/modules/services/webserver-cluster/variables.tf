
variable "server_port" {
  description = "Port to use for the instance"
  type        = number
  default     = 8080
}

variable "cluster_name" {
  description = "the name to use for all the cluster resources"
  type =   string
}

variable "db_remote_state_bucket" {
  description = "the name of the bucket where the remote state for the database is stored"
  type =   string
}

variable "db_remote_state_key" {
  description = "path for db_remote_state_bucket"
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

variable "server_text" {
  type = string
  default = "server_text"
}