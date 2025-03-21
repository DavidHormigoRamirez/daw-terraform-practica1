# Grupo de seguridad para Web
resource "aws_security_group" "web_access" {
    name = "WEB-ANYWHERE"
    description = "HTTP and HTTPS access"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ var.ssh_sg_id ]
    }
    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

data "local_file" "user_data_script" {
  filename = "${path.module}/userdata.sh"
}

# Servidor Web
resource "aws_instance" "webserver" {
    security_groups = [ aws_security_group.web_access.name ]
    ami = var.ami_id
    instance_type = "t2.medium"
    key_name = "vockey"
    user_data = data.local_file.user_data_script.content
    tags = {
      Name = "WebServer"
    }
  
}