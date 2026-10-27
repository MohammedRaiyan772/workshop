variable "vpc1_cidr" {}
variable "vpc1_name" {}
variable "sub1_name" {}
variable "sub1_cidr" {}
variable "igw1_name" {}
variable "RT1_name" {}
variable "ami1_id" {}
variable "key1_name" {}
variable "ec2-1_type" {}
variable "ec2-1_name" {}
variable "bucket_name" {}
variable "s3_name" {}
variable "s3_env" {}
variable "db_name" {}
variable "LB_name" {}
variable "subnet_ids" {}
variable "security_group_id" {}
variable "vpc_id" {}
variable "public_subnet_id" {}
variable "vpc-1_id" {}
# RDS variables
variable "rds_subnet1_cidr" {
  description = "CIDR for RDS subnet 1"
  type        = string
}

variable "rds_subnet2_cidr" {
  description = "CIDR for RDS subnet 2"
  type        = string
}

variable "rds_az1" {
  description = "Availability Zone for RDS subnet 1"
  type        = string
}

variable "rds_az2" {
  description = "Availability Zone for RDS subnet 2"
  type        = string
}

variable "rds_identifier" {
  description = "RDS database instance identifier"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_db_name" {
  description = "Initial database name"
  type        = string
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}