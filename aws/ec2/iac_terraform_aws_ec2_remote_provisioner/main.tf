provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# This resource block creates aws ec2 instance with the details provided
resource "aws_instance" "ec2_instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${var.sg_id}"]
  subnet_id = "${var.subnet_id}"
  tags = {
    Name = "${var.stack_name}-ec2-instance"
  }

 provisioner "remote-exec" {
   inline = [ "cd $home","mkdir test", "mkdir test2"]
   connection {
     type     = "ssh"
     user     = "root"
     host = "${self.private_ip}"
     private_key = "${file("private_key.pem")}"
   }
 }


}
