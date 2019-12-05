output "public_ip" {
  value = "${aws_instance.ec-2-web.public_ip}"
}