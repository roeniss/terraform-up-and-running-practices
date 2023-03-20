provider "aws" {
  region = "us-east-2"
}

variable "user_names" {
  type = list(string)
  default = ["neo", "trinity", "morpheus"]
}


resource "aws_iam_user" "default" {
#   count = "${length(var.user_names)}"
  for_each = toset(var.user_names)
  name = each.value
}

output "all_arns" {
  value = values(aws_iam_user.default)[*].arn
}

output "upper_user_names" {
	value = [for user_name in var.user_names : upper(user_name)]
}

output "short_upper_user_names" {
	value = [for user_name in var.user_names : upper(user_name) if length(user_name) < 5]
}
