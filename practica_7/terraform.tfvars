virginia_cidr = "10.0.0.0/16"
# public_subnet = "10.0.0.0/24"
# privade_subnet = "10.0.1.0/24"

subnets = [ "10.0.0.0/24","10.0.1.0/24" ]

tags = {
    "env" = "dev"
    "owner" = "Patricia"
    "cloud" = "AWS"
    "IAC" = "Terraform"
    "IAC_Version" = "1.9.3"
    "project" = "cerberus"
    "region" = "virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

#enable_monitoring =  true

#enable_monitoring_num = 0