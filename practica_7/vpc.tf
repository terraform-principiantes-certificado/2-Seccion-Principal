resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    "Name" = "vpc_virginia-${local.sufix}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  cidr_block =var.subnets[0]
  map_public_ip_on_launch = true # al poner true le estamos indicando que le asigne direcciones ip públicas a las instancia donde lo despleguemos
  tags = {
    "Name" = "Public_Subnet-${local.sufix}"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    "Name" = "Private_Subnet-${local.sufix}"
  }
  depends_on = [ aws_subnet.public_subnet ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public crt-${local.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id 
}


resource "aws_security_group" "sg_public_instace" {
  name        = "Public Instance SG"
  description = "Allow inbound SSH and All egress Traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  dynamic "ingress" {
    for_each = var.ingress_port_list
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 significa todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Instance SG-${local.sufix}"
  }
}
