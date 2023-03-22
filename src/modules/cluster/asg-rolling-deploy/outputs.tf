output "asg_name"{
	value = aws_autoscaling_group.default.name
	description = "value of the asg name"
}

output "intstance_security_group_id"{
	value = aws_security_group.albㅎ.id
	description = "value of the instance security group id"
}