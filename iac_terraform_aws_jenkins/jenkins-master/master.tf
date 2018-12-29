resource "aws_instance" "jenkins_master_instance" {

  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.public_subnet_id}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_block_volume_size}"
  }
  vpc_security_group_ids = ["${var.security_group_ids}"]

  tags = {
    Name          = "jenkins-master-instance"
  }
  key_name = "${var.key_pair_name}"
}

output "private_ip" {
  value = "${aws_instance.jenkins_master_instance.public_ip}"
}

output "instance_id" {
  value = "${aws_instance.jenkins_master_instance.id}"
}

resource "null_resource" "jenkins_remote_provisioner" {

  provisioner "remote-exec" {
    inline = ["sudo dnf -y install python"]

    connection {
      host        = "${aws_instance.jenkins_master_instance.public_ip}"
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./artifacts/jenkins.pem")}"
    }
  }

}

resource "aws_elb" "jenkins_master_elb" {
  name = "${var.master_elb_name}"

  security_groups = ["${var.master_elb_sg}"]
  subnets         = "${var.master_elb_subnets}"

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.master_elb_ssl_cert}"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = ["${aws_instance.jenkins_master_instance.id}"]
  cross_zone_load_balancing   = true
  internal                    = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.master_elb_name}"
  }
}

output "master_elb_dns" {
  value = "${aws_elb.jenkins_master_elb.dns_name}"
}

output "master_elb_zoneid" {
  value = "${aws_elb.jenkins_master_elb.zone_id}"
}
