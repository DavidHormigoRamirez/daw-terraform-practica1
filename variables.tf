# Id de la Imagen de Ubuntu 22.04
data "aws_ami" "ubuntu" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

}


variable "region" {
    type = string
    default = "us-east-1"
}