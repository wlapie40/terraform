provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket         = "sfigiel-terraform-state"
    key            = "~/workspaces-example/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "sfigiel-terraform-file-locks"
    encrypt        = true

  }
}
resource "aws_instance" "example" {
  ami           = "ami-05f37c3995fffb4fd"
  instance_type = "t2.micro"

}
