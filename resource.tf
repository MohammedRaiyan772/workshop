#aws_vpc
resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc1_cidr
  tags = {
    Name = var.vpc1_name
  }
}
#aws_subnet
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.sub1_cidr
  tags = {
    Name = var.sub1_name
  }
}
#aws_route_table
resource "aws_route_table" "RT1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = var.RT1_name
  }
}
#aws_route_table_association
resource "aws_route_table_association" "association1" {
  route_table_id = aws_route_table.RT1.id
  subnet_id      = aws_subnet.sub1.id
}
#aws_routes
resource "aws_route" "route1" {
  route_table_id         = aws_route_table.RT1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw1.id
}
#aws_internet_gateway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = var.igw1_name
  }
}
#aws_ec2_instance
resource "aws_instance" "ec2-1" {
  ami                         = var.ami1_id
  key_name                    = var.key1_name
  instance_type               = var.ec2-1_type
  subnet_id                   = aws_subnet.sub1.id
  associate_public_ip_address = true
  tags = {
    Name = var.ec2-1_name
  }
}
#aws_s3_bucket
resource "aws_s3_bucket" "s3-1" {
  bucket = var.bucket_name
  tags = {
    Name = var.s3_name
    env  = var.s3_env
  }
}
#aws_dynamoDB_table
resource "aws_dynamodb_table" "table" {
  name         = var.db_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "emp"

  attribute {
    name = "emp"
    type = "S"
  }
}
locals {
  employees = {
    101 = {
      name       = "Raiyan"
      department = "devops"
    }
    102 = {
      name       = "ahmed"
      department = "HR"
    }
    103 = {
      name       = "khalid"
      department = "cloud"
    }
  }
}
#aws_dynamodb_table_item
resource "aws_dynamodb_table_item" "employee" {
  for_each = local.employees

  table_name = aws_dynamodb_table.table.name
  hash_key   = "emp"

  item = jsonencode({
    emp        = { S = each.key }
    name       = { S = each.value.name }
    department = { S = each.value.department }
  })
}
#load_balancer
resource "aws_lb" "my_alb" {
  name               = "LB1"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_id
  tags = {
    Name = var.LB_name
  }
}
#target_group
resource "aws_lb_target_group" "my_tg" {
  name     = "TG1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "TG1"
  }
}
#listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}
#allocate_nat eip
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat_eip"
  }
}
#Nat_gateway
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id
  tags = {
    Name = "NAT_Gateway"
  }
  depends_on = [aws_eip.nat_eip]
}
#vpc_peering
data "aws_vpc" "vpc1" {
  id = var.vpc-1_id
}
data "aws_vpc" "VPC_1" {
  id = aws_vpc.vpc1.id
}
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = data.aws_vpc.vpc1.id
  peer_vpc_id = data.aws_vpc.VPC_1.id
  auto_accept = true
  tags = {
    Name = "peering1"
  }
}
#RDS private subnet 1
resource "aws_subnet" "rds_subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.rds_subnet1_cidr
  availability_zone = var.rds_az1

  tags = {
    Name = "RDS-Private-Subnet-1"
  }
}

# RDS private subnet 2
resource "aws_subnet" "rds_subnet2" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.rds_subnet2_cidr
  availability_zone = var.rds_az2

  tags = {
    Name = "RDS-Private-Subnet-2"
  }
}

# RDS DB subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-private-subnet-group"

  subnet_ids = [
    aws_subnet.rds_subnet1.id,
    aws_subnet.rds_subnet2.id
  ]

  tags = {
    Name = "RDS-Subnet-Group"
  }
}

# RDS security group
resource "aws_security_group" "rds_sg" {
  name        = "rds-mysql-sg"
  description = "Allow MySQL access from the VPC"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc1_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-Security-Group"
  }
}

# RDS MySQL database
resource "aws_db_instance" "mysql_db" {
  identifier = var.rds_identifier

  engine         = "mysql"
  instance_class = var.rds_instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.rds_db_name
  username = var.rds_username
  password = var.rds_password
  port     = 3306

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible     = false
  multi_az                = false
  storage_encrypted       = true
  backup_retention_period = 1

  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "MySQL-RDS"
    Env  = "dev"
  }
}