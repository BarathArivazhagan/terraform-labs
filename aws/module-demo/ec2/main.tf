
resource "aws_instance" "web-server" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${var.sg_id}"]
  subnet_id = "${var.subnet_id}"
  tags = {
    Name = "${var.stack_name}-ec2-instance"
  }


}