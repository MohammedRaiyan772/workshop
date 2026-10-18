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