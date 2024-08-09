

resource "aws_instance" "public_isntance" {
  ami                     = "ami-0ba9883b710b05ac6"
  instance_type           = "t2.micro"
  subnet_id =  aws_subnet.public_subnet.id 
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instace.id]
  # lifecycle {
  #   create_before_destroy = true
  #   prevent_destroy = true
  #   ignore_changes = [ ami,subnet_id ]
  #   replace_triggered_by = [ 
  #     aws_subnet.private_subnet
  #    ]
  # }
   user_data              = file("scripts/userdata.sh")


  provisioner "local-exec" {
    command = "echo instancia creada con IP ${aws_instance.public_instance.public_ip} >> datos_instancia.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo Instancia ${self.public_ip} Destruida >> datos_instancia.txt"

  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo 'hola mundo' > ~/saludo.txt"
  #   ]
}

