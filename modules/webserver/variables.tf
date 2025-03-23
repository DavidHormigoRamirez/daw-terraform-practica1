#Input
variable "ami_id" {
    description = "Id Ami"
    type = string
}

variable "ssh_sg_id" {
    description = "Id grupo de seguridad SSH"
    type = string
}

#Datos locales
data "local_file" "user_data_script" {
  filename = "${path.module}/userdata.sh"
}