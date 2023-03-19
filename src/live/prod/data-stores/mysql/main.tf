terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-state-jkhqwef"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks-jkhqwef"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier        = "terraform-up-and-running"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"
  #   password = data.aws_secretsmanager_secret_version.db_password.secret_string
  password = var.db_password
  skip_final_snapshot = true
}

# data "aws_secretsmanager_secret_version" "db_password" {
#   secret_id = "mysql-master-password-prod"
# }
