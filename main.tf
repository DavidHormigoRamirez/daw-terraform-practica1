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
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
  backend "s3" {
    bucket = "terraform-backend-495923475593"
    key = "practica1/key"
    region = "us-east-1"
    
  }
}

provider "aws" {
  region = var.region
}

module "bastion" {
  source = "./modules/bastion"
  ami_id = data.aws_ami.ubuntu.id
}

module "webserver" {
  source    = "./modules/webserver"
  ami_id    = data.aws_ami.ubuntu.id
  ssh_sg_id = module.bastion.sg_ssh_id
}


output "webserver_address" {
  value = module.webserver.public_dns
}

