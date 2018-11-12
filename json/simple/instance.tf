variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
default = "us-east-1"
}
variable "WIN_AMIS" {
type = "map" default = {
us-east-1 = "ami-05c2d010ff77e020c"

}
}
variable "PATH_TO_PRIVATE_KEY" { default = "IMP" }
}


provider "aws" {
access_key = "${var.AWS_ACCESS_KEY}"
secret_key = "${var.AWS_SECRET_KEY}"
region = "${var.AWS_REGION}" }
resource "aws_key_pair" "test" {
key_name = "IMP"
}

resource "aws_instance" "winrm" {
ami = "${lookup(var.WIN_AMIS, var.AWS_REGION)}"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.us-east-1a-public.id}"
associate_public_ip_address = true
key_name = "${aws_key_pair.IMP.key_name}"
"get_password_data"     =   true
"connection" = {
"password" =  "${rsadecrypt(aws_instance.PubInst.password_data,file(\"IMP.pem\"))}"
}
vpc_security_group_ids=["${aws_security_group.allow-all.id}"]
}

resource "aws_security_group" "allow-all" {
vpc_id =  "${aws_vpc.IMP_vpc.id}"
name="allow-all"
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 0
to_port = 6556
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
   from_port   = 5985
   to_port     = 5986
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
tags {
Name = "allow-RDP"
}
}
