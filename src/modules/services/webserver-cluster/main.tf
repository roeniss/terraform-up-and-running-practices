terraform {
  required_version = "1.4.0"
 
  backend "s3" {
    bucket         = "terraform-up-and-running-state-jkhqwef"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks-jkhqwef"
    encrypt        = true
  }
}

# provider "aws" {
#   region = "us-east-2"
# }

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "db" { 
	backend = "s3"

	config = {
		bucket = var.db_remote_state_bucket # "terraform-up-and-running-state-jkhqwef"
		key = var.db_remote_state_key # "stage/data-stores/mysql/terraform.tfstate"
		region = "us-east-2"
	}
}

locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port    = data.terraform_remote_state.db.outputs.port
    server_text = var.server_text
  }
}



resource "aws_lb_listener_rule" "default" {
  listener_arn = aws_lb_listener.default.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group" "default" {
  name     = "${var.cluster_name}-lb-tg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}
