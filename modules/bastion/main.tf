# Grupo de seguridad para SSH
resource "aws_security_group" "ssh_access" {
    name = "${terraform.workspace}-SSH-ANYWHERE"
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


# Servidor Bastion
resource "aws_instance" "bastion" {
    security_groups = [ aws_security_group.ssh_access.name ]
    ami = var.ami_id
    instance_type = "t2.medium"
    key_name = "vockey"
    tags = {
        Name = "${terraform.workspace}-Bastion"
    }
}

