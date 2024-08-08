

resource "aws_instance" "public_isntance" {
  ami                     = "ami-0ba9883b710b05ac6"
  instance_type           = "t2.micro"
  subnet_id =  aws_subnet.public_subnet.id 
  key_name = data.aws_key_pair.key.key_name
  # lifecycle {
  #   create_before_destroy = true
  #   prevent_destroy = true
  #   ignore_changes = [ ami,subnet_id ]
  #   replace_triggered_by = [ 
  #     aws_subnet.private_subnet
  #    ]
  # }
}