provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

resource "aws_launch_configuration" "demo_launch_configuration" {
  name_prefix   =  var.name_prefix
  image_id      =  var.ami
  instance_type =  var.instance_type
  key_name = var.key_name
  lifecycle {
    create_before_destroy = true
  }
  security_groups = [aws_security_group.asg_security_group.id]
  user_data_base64 = base64encode(file("user_data"))

}


resource "aws_autoscaling_group" "demo_autoscaling_group" {
  availability_zones = data.aws_availability_zones.azs.names
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  launch_configuration = aws_launch_configuration.demo_launch_configuration.name
  vpc_zone_identifier = data.aws_subnet_ids.subnets.ids
  target_group_arns = [aws_lb_target_group.load_balancer_target_group.arn]
  lifecycle {
    create_before_destroy = true
  }
  tags = [
    {
      key                 = "Name"
      value               = join("-",[var.stack_name,"node"])
      propagate_at_launch = true
    }
  ]

}

data "aws_instances" "asg_instances" {


  instance_tags = {
    "Name" = join("-",[var.stack_name,"node"])
  }
  instance_state_names = ["running"]
  depends_on = [aws_autoscaling_group.demo_autoscaling_group]
}



resource "aws_lb" "load_balancer" {

  enable_cross_zone_load_balancing = true
  internal = false
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.subnets.ids
  tags = {
    Name = join("-",[var.stack_name,"lb"])
  }
}

resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = var.lb_port
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target_group.arn
  }
}


resource "aws_lb_target_group" "load_balancer_target_group" {
  name = join("-",[var.stack_name,"target-group"])
  port = var.app_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

resource "aws_lb_target_group_attachment" "load_balancer_target_group_attachment" {
  count = aws_autoscaling_group.demo_autoscaling_group.desired_capacity
  target_group_arn = aws_lb_target_group.load_balancer_target_group.arn
  target_id        = data.aws_instances.asg_instances.ids[count.index]
  port             = var.lb_port
  depends_on = [aws_autoscaling_group.demo_autoscaling_group]
}

resource "aws_security_group" "lb_security_group" {

  name = join("-",[var.stack_name,"lb-sg"])
  description = join("-",[var.stack_name,"lb-sg"])
  vpc_id = var.vpc_id
}


resource "aws_security_group" "asg_security_group" {
  name = join("-",[var.stack_name,"node-sg"])
  description = join("-",[var.stack_name,"node-sg"])
  vpc_id = var.vpc_id

}

resource "aws_security_group_rule" "lb_ingress_rule" {
  from_port = var.lb_port
  protocol = "TCP"
  security_group_id = aws_security_group.lb_security_group.id
  to_port = var.lb_port
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_egress_rule" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.lb_security_group.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2_instance_ingress_rule" {
  from_port = var.app_port
  protocol = "TCP"
  security_group_id = aws_security_group.asg_security_group.id
  to_port = var.app_port
  type = "ingress"
  source_security_group_id = aws_security_group.lb_security_group.id
}

resource "aws_security_group_rule" "ec2_instance_egress_rule" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.asg_security_group.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}



