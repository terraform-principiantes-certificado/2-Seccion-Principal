# Ejemplo con count y list de string


# variable "instacias" {
#   description = "Nombre de las instacias"
#   type = list(string)
#   default = [ "apache","mysql","jumpserver" ]
# }


# resource "aws_instance" "public_instance" {
#   count = length(var.instacias)
#   ami                     = "ami-0ba9883b710b05ac6"
#   instance_type           = "t2.micro"
#   subnet_id =  aws_subnet.public_subnet.id 
#   key_name = data.aws_key_pair.key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_public_instace.id]

#   tags = {
#     "Name" = var.instacias[count.index]
#   }
  
# }
# Ejemplo con foreach

variable "instacias" {
  description = "Nombre de las instacias"
  #type = set(string)
  type = list(string)
  default = [ "apache","mysql","jumpserver" ]
}


resource "aws_instance" "public_instance" {
  #for_each = var.instacias
  for_each = toset(var.instacias)
  ami                     = "ami-0ba9883b710b05ac6"
  instance_type           = "t2.micro"
  subnet_id =  aws_subnet.public_subnet.id 
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instace.id]

  tags = {
    "Name" = each.value
  }
  
}
