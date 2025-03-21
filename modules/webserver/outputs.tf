output "public_dns" {
    description = "Web server public dns"
    value = "http://${aws_instance.webserver.public_dns}"
  }