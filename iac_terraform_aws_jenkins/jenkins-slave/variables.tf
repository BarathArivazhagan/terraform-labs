variable "instance_type" {
  type        = "string"
  description = "Type of the EC2 instance to be launched"
  default     = "t2.medium"
}

variable "key_pair_name" {
  type        = "string"
  description = "Key pair that needs to be attached to the instance"

}

variable "ami" {
  type        = "string"
  description = "AMI to be used when launching the instances"
}

variable "subnet_id" {
  type        = "string"
  description = "Subnet in which the EC2 instance should be launched"
}

variable "security_group_ids" {
  type = "list"
}
