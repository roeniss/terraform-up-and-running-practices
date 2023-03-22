
resource "aws_launch_configuration" "default" {
  image_id        = "ami-00eeedc4036573771"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.asg.id]

  # user_data = data.template_file.user_data.rendered
  user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "default" {
  name = "${var.cluster_name}-${aws_launch_configuration.default.name}"
  # name = "${var.cluster_name}-"
  launch_configuration = aws_launch_configuration.default.id
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  # min_elb_capacity = var.min_size

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg-default"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags : key => upper(value) if key != "Name"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
	count = var.enable_autoscaling ? 1 : 0

	autoscaling_group_name = aws_autoscaling_group.default.name
	scheduled_action_name = "scale-out-during-business-hours"
	min_size = 2
	max_size = 10
	desired_capacity = 10
	recurrence = "0 9 * * * "
}

resource "aws_autoscaling_schedule" "scale_in_during_night" {
	count = var.enable_autoscaling ? 1 : 0

	autoscaling_group_name = aws_autoscaling_group.default.name
	scheduled_action_name = "scale-in-during-night"
	min_size = 2
	max_size = 10
	desired_capacity = 2
	recurrence = "0 17 * * * "
}

resource "aws_security_group" "asg" {
  name = "${var.cluster_name}-asg-sg"
}

resource "aws_security_group_rule" "asg_allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.asg.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}



resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "${var.cluster_name}-high-cpu-utilization"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.default.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  unit                = "Percent"
}


resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
#   count = format("%.1s", var.instance_type) == "t" ? 1 : 0
  count = 1

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.default.sname
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}