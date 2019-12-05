provider "aws" {
  region = var.AWS_REGION
}

resource "aws_vpc" "prod-vpc" {
     cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"

  tags = {
    Name = "prod-vpc-tf"
  }
}

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id     = "${aws_vpc.prod-vpc.id }"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "eu-west-2a"

  tags = {
    Name = "prod-subnet-public-1-eu-west-2a-tf"
  }
}

resource "aws_subnet" "prod-subnet-private-2" {
  vpc_id     = "${aws_vpc.prod-vpc.id }"
  cidr_block = "10.0.16.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "prod-subnet-private-2-eu-west-2b-tf"
  }
}

resource "aws_subnet" "prod-subnet-private-3" {
  vpc_id     = "${aws_vpc.prod-vpc.id }"
  cidr_block = "10.0.32.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "prod-subnet-private-3-eu-west-2c-tf"
  }
}