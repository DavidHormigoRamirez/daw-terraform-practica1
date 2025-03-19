# ===================================================================================================== #
# PRACTICA 1                                                                                            #
# ===================================================================================================== #
# Plan de terraform para la practica 1
# Crea una infraestructura de AWS para tener un servidor web con Apache
# Esta infraestructura debe tener un servidor de Bastion que permita el accesso mediante SSH
# Para ello crea los siguientes recursos:
# 1. Grupo de Seguridad SSH que permita tráfico en el puerto 22 desde cualquier ip
# 2. Grupo de Seguridad Web que permita tráfico 80 y 443 desde cualqueir ip, ademas permtia trafico en 
#    en el puerto 22 desde el grupo de seguridad SSH
# 3. Un servidor Ubuntu 22.04 llamado Bastion con el grupo de seguridad SSH asociado
# 4. Otro servidor Ubuntu 22.04 llamado WebServer con Apache Web server instalado y el grupo de seguridad
#    web asociado


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

# Id de la Imagen de Ubuntu 22.04
data "aws_ami" "ubuntu" {
    owners = [ "amazon" ]
    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
  
}

# Grupo de seguridad para SSH
resource "aws_security_group" "ssh_access" {
    name = "SSH-ANYWHERE"
    description = "SSH Access"
    ingress  {
        from_port = 22
        to_port = 22
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


# Grupo de seguridad para Web
resource "aws_security_group" "web_access" {
    name = "WEB-ANYWHERE"
    description = "HTTP and HTTPS access"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.ssh_access.id ]
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


# Servidor Bastion
resource "aws_instance" "bastion" {
    security_groups = [ aws_security_group.ssh_access.name ]
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.medium"
    key_name = "vockey"
    tags = {
        Name = "Bastion"
    }
}

# Servidor Web
resource "aws_instance" "webserver" {
    security_groups = [ aws_security_group.web_access.name ]
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.medium"
    key_name = "vockey"
    user_data = file("userdata-scripts/webserver.sh")
    tags = {
      Name = "WebServer"
    }
  
}

