
variable "db_remote_state_bucket" {
  description = "the name of the bucket where the remote state for the database is stored"
  type =   string
}

variable "db_remote_state_key" {
  description = "path for db_remote_state_bucket"
  type =   string
}


variable "server_text" {
  type = string
  default = "server_text"
}