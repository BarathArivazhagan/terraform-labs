

module "vpc" {
  source = "../vpc"

  aws_region                 = "${var.aws_region}"
  aws_internet_gateway_name  = "${var.aws_internet_gateway_name}"
  vpc_name                   = "${var.vpc_name}"
  private_subnet_cidr_a      = "${var.private_subnet_cidr_a}"
  public_subnet_cidr_a       = "${var.public_subnet_cidr_a}"
  vpc_cidr                   = "${var.vpc_cidr}"
}

module "ecr"{
  source = "../ecr"

  environment               = "${var.environment}"
  ecr_name                  = "${var.ecr_name}"
  max_image_count           = "${var.max_image_count}"
  user                      = "${var.user}"
  private_key_path          = "${var.private_key_path}"
  template_source_path      = "${var.template_source_path}"
  template_destination_path = "${var.template_destination_path}"

}


resource "aws_security_group" "alb_sg" {
  name        = "tf-ecs-alb"
  description = "controls access to the ALB"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name        = "tf-ecs-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol        = "tcp"
    from_port       = 0
    to_port         = 65535
    security_groups = ["${aws_security_group.alb_sg.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_alb" "alb" {
  name            = "tf-ecs-chat"
  subnets         = ["${module.vpc.public_subnet_id}"]
  security_groups = ["${aws_security_group.alb_sg.id}"]
}

resource "aws_alb_target_group" "app" {
  name        = "tf-ecs-chat"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${module.vpc.vpc_id}"
  target_type = "ip"
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.app.id}"
    type             = "forward"
  }
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}



resource "aws_ecs_task_definition" "app_definition" {
  family                   = "${var.app_family_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.host_port}
      }
    ]
  }
]
DEFINITION
}


resource "aws_ecs_service" "ecs_service" {
  name            = "tf-ecs-service"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.app_definition.arn}"
  desired_count   = "${var.task_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_task_sg.id}"]
    subnets         = ["${module.vpc.private_subnet_id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }


  depends_on = [
    "aws_alb_listener.front_end","aws_ecs_cluster.ecs_cluster"
  ]
}