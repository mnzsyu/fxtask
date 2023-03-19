variable "aws_region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "ami_id" {
  type    = string
  default = "ami-06616b7884ac98cdd"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type = string
}
