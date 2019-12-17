resource "aws_instance" "ec-2-web" {
  ami = "${lookup(var.AMI, var.AWS_REGION)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]

  key_name = "${aws_key_pair.key_pair.id}"

  tags = {
    Name = "prod-public-tf"
  }

}

resource "aws_key_pair" "key_pair" {
  key_name = "key_pair"
  public_key = "${file("~/aws_perm/terraform-keypair-public")}"
}

//terraform {
//  backend "s3" {
//    bucket         = "sfigiel-terraform-state"
//    key            = "vpc-basic/terraform.tfstate"
//    region         = "eu-west-2"
//    dynamodb_table = "sfigiel-terraform-file-locks"
//    encrypt        = true
//
//  }
//}
