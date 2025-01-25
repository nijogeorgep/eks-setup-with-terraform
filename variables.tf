variable "cluster_name" {
  default = "cloudwalkers"
}

variable "cluster_version" {
  default = 1.31
}

variable "environment_name" {
  default = "dev"
}

variable "region_name" {
  default = "us-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "ami_release_version" {
  default = ""
}

variable "aws_profile" {
  default = "my-personal-aws"
}