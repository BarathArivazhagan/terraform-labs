
# This resource block creates aws ec2 instance with the details provided
resource "aws_instance" "ec2_instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${var.sg_group_id}"]
  subnet_id = "${var.subnet_id}"
  user_data = "${file("user_data")}"
  tags = {
    Name = "${var.stack_name}-instance"
  }


}
