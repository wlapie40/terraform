resource "aws_internet_gateway" "prod-igw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags = {
    Name = "prod-igw-tf"
  }
}

resource "aws_route_table" "prod-public-crt" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = "${aws_internet_gateway.prod-igw.id}"
  }

  tags = {
    Name = "prod-public-crt"
  }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  route_table_id = "${aws_route_table.prod-public-crt.id}"
}

resource "aws_security_group" "sg" {
  name = "tf-sg-example"
  vpc_id = aws_vpc.prod-vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = [var.xps_ip]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.xps_ip]
  }

  tags = {
    Name = "ssh-allowed-tf"
  }
}