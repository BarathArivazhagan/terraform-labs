variable "vpc_id" {
  type        = "string"
  description = "VPC to be used when creating security groups"
}

variable "jenkins_sg_name" {
  type        = "string"
  description = "Name of Jenkins Security Group"
}
