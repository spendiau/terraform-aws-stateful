resource "aws_autoscaling_group" "asg" {
  count               = var.instance_count
  name                = "${var.name}-${count.index}"
  min_size            = 1
  max_size            = var.max_size
  vpc_zone_identifier = [var.instances_subnet_ids[count.index]]

  enabled_metrics     = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity"
  ]

  launch_template {
    id      = var.launch_template_id != "" ? var.launch_template_id : aws_launch_template.default.id 
    version = "$Latest"
  }

  # tags = concat(
  #   [for key, value in var.tags : { key : key, value : value, propagate_at_launch : true }],
  #   [{
  #     key                 = "Name"
  #     value               = var.name
  #     propagate_at_launch = true
  #   }]
  # )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]
  }
}