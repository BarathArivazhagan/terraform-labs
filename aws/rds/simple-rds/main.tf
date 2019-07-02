provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"


}

# resource block to create db instance
resource "aws_db_instance" "db_instance" {
  name = "${var.stack_name}-${var.database_name}"
  instance_class = "${var.db_instance_class}}"
  identifier = "${var.database_name}"
  vpc_security_group_ids = ["${aws_security_group.database_security_group.id}"]
  db_subnet_group_name = "${var.db_subnet_group_name}"
  allocated_storage = "${var.db_allocated_storage}"
  engine = "${var.db_engine}"
  engine_version       = "${var.db_engine_version}"
  username = "${var.database_master_username}"
  password = "${var.database_master_password}"
  port = "${var.database_port}"

}

output "rds_database_endpoint" {
  value = "${aws_db_instance.db_instance.endpoint}"
}



resource "aws_security_group" "database_security_group" {

  name        = "${var.stack_name}-database_security_group"
  description = "RDS security group for RDS db instance"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = "${var.database_port}"
    to_port     = "${var.database_port}"
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
    Name = "${var.stack_name}-database_security_group"
  }
}

