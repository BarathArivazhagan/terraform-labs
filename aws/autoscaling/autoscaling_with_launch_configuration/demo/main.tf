provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_launch_configuration" "demo_launch_configuration" {
  name_prefix   =  var.name_prefix
  image_id      =  var.ami
  instance_type =  var.instance_type
  key_name = var.key_name
  lifecycle {
    create_before_destroy = true
  }


}


resource "aws_autoscaling_group" "demo_autoscaling_group" {
  availability_zones = data.aws_availability_zones.azs.names
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  launch_configuration = aws_launch_configuration.demo_launch_configuration.name

  lifecycle {
    create_before_destroy = true
  }


}



resource "aws_security_group" "asg_security_group" {

}