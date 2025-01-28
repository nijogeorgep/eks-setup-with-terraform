variable "cluster_name" {
  description = "Name of the EKS Cluster"
  default = "cloudwalkers"
}

variable "cluster_version" {
  description = "Version of Kubernetes in the EKS Cluster"
  default = 1.31
}

variable "environment_name" {
  description = "Your environment DEV|LAB|PROD|SECURE|CORP|DW"
  default = "dev"
}

variable "region_name" {
  description = "Region of Infrastructure"
  default = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR Range for the VPC"
  default = "10.0.0.0/16"
}

variable "ami_release_version" {
  description = "AMI version for the EKS Nodes, empty value means AMI supported with Kubernetes version auto selected."
  default = ""
}

variable "aws_profile" {
  description = "AWS profile used to connect with AWS Environment"
  default = "my-personal-aws"
}