output "vpc_id" {
  value = data.aws_vpc.vpc.id
  description = "The id of VPC"
}

output "public_ip" {
  value       = aws_launch_configuration.example.associate_public_ip_address
  description = "The public IP address of the web server"
}

output "alb_dns_name" {
  value       = aws_lb.aws_lb.dns_name
  description = "The domain name of the load balancer"
}