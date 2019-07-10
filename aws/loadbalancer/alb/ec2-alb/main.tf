provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# This resource block creates aws ec2 instance with the details provided
resource "aws_instance" "ec2_instance" {
  count = "${var.number_of_instances > 0 ? var.number_of_instances : 1}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.ec2_instance_security_group.id}"]
  subnet_id = "${var.subnet_id}"
  user_data = "${file("user_data")}"
  tags = {
    Name = "${var.stack_name}-instance"
  }

}


# This resource block creates aws security group within VPC ID with the details provided
resource "aws_security_group" "ec2_instance_security_group" {
  name        = "${var.stack_name}_sg"
  description = "${var.stack_name}_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["${aws_security_group.elb_security_group.id}"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["${aws_security_group.elb_security_group.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stack_name}_sg"
  }
}

# This resource block creates aws security group within VPC ID with the details provided
resource "aws_security_group" "elb_security_group" {
  name        = "${var.stack_name}_elb_sg"
  description = "${var.stack_name}_elb_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stack_name}_elb_sg"
  }
}

# resource to create load balancer with type as neetwork for network load balancer
resource "aws_lb" "elb" {

  name = "${var.stack_name}-elb"
  subnets = ["${var.subnet_id}"]
  internal = false
  enable_deletion_protection = false
  load_balancer_type = "network"
  tags = {
    Name= "${var.stack_name}-elb"
  }
}

# resource to attach listener to the load balancer
resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = "${aws_lb.elb.arn}"
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.elb_target_group.arn}"
  }
}

# resource to create a target group
resource "aws_lb_target_group" "elb_target_group" {
  name     = "${var.stack_name}-lb-tg"
  port     = 8080
  protocol = "TCP"
  target_type = "instance"
  vpc_id   = "${var.vpc_id}"

}

# resource to create a target group attachment with ec2 instances
resource "aws_lb_target_group_attachment" "ec2_lb_target_group_attachment" {
  count = "${var.number_of_instances > 0 ? var.number_of_instances : 1}"
  target_group_arn = "${aws_lb_target_group.elb_target_group.arn}"
  target_id        = "${aws_instance.ec2_instance[count.index].id}"
  port             = 80
}



output "ec2_instances_ids" {
  value = ["${aws_instance.ec2_instance.*.id}"]
}



