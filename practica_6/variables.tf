variable "virginia_cidr" {
    description = "CIDR Virginia"
    type = string
    ## sensitive = true
}
# variable "public_subnet" {
#     description = "CDIR public subnet"
#     type = string
# }
# variable "privade_subnet" {
#   description = "CDIR privade subnet"
#   type = string
# }

variable "subnets" {
  description = "Lista de subnets"
  type = list(string) 
}
variable "tags" {
  description = "Tags del proyecto"
  type = map(string)
}
variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type = string
  
}