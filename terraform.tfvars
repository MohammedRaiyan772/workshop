vpc1_cidr   = "172.16.0.0/16"
vpc1_name   = "VPC-1"
sub1_cidr   = "172.16.0.0/24"
sub1_name   = "subnet1"
RT1_name    = "RT1"
igw1_name   = "igw1"
ami1_id     = "ami-04394a3a96907e9ec"
key1_name   = "terra"
ec2-1_type  = "t3.micro"
ec2-1_name  = "instance1"
bucket_name = "raiyan12"
s3_name     = "bucket1"
s3_env      = "dev"
db_name     = "table1"
LB_name     = "LB1"
subnet_ids = [
  "subnet-01af1061e06390466",
  "subnet-0b3baf622f09aafb5"
]
security_group_id = ["sg-04539ae44acab47f9"]
vpc_id            = "vpc-0e4bd321f83c84661"
public_subnet_id  = "subnet-08a4b749add16e401"
vpc-1_id          = "vpc-0e4bd321f83c84661"
#RDS private subnets
rds_subnet1_cidr = "172.16.1.0/24"
rds_subnet2_cidr = "172.16.2.0/24"

# Mumbai region Availability Zones
rds_az1 = "ap-south-1a"
rds_az2 = "ap-south-1b"

# RDS configuration
rds_identifier     = "my-mysql-db"
rds_instance_class = "db.t3.micro"
rds_db_name        = "employees"
rds_username       = "dbadmin"

# Replace with your own strong password
rds_password = "ReplaceWithYourOwnStrongPassword123!"