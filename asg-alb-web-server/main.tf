provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket         = "sfigiel-terraform-state"
    key            = "~/Projects/Terraform/Learning/vpc-basic/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "sfigiel-terraform-file-locks"
    encrypt        = true

  }
}


resource "aws_launch_configuration" "example" {
  image_id = "ami-05f37c3995fffb4fd"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sfigiel-tf-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo 'Hello, World' > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ASG
resource "aws_autoscaling_group" "sfigiel-asg" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnet_ids.subnet.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  max_size = 10
  min_size = 2

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "sfigiel-terraform-asg-example"
  }
}

#SG
resource "aws_security_group" "sfigiel-tf-sg" {
  name = "terraform-example-instance"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#data source
data "aws_vpc" "vpc" {
  default = true
//  id = "vpc-00000000000"
}

data "aws_subnet_ids" "subnet" {
  vpc_id = data.aws_vpc.vpc.id
}


resource "aws_lb" "aws_lb" {
  name = var.alb_name
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.subnet.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.aws_lb.arn
  port = 80
  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    field  = "path-pattern"
    values = ["*"]
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}