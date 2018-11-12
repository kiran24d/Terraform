# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
}

#Create VPC
  resource "aws_vpc" "IMP_vpc" {
   cidr_block       = "10.20.0.0/16"
   tags {
     Name = "us-east-1-10.20.0.0/16"
   }
}

#create AZS
data "aws_availability_zones" "azs" {}

#create subnets
resource "aws_subnet" "us-east-1a-public" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
    cidr_block = "10.20.1.0/24"
    availability_zone = "${data.aws_availability_zones.azs.names[0]}"

    tags {
        Name = "us-east-1_10.20.1.0/24_Pub"
    }
}
resource "aws_subnet" "us-east-1b-public" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
    cidr_block = "10.20.2.0/24"
    availability_zone = "${data.aws_availability_zones.azs.names[1]}"

    tags {
        Name = "us-east-1b_10.20.2.0/24_Pub"
    }
}
resource "aws_subnet" "us-east-1c-public" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
    cidr_block = "10.20.3.0/24"
  availability_zone = "${data.aws_availability_zones.azs.names[2]}"

    tags {
        Name = "us-east-1c_10.20.3.0/24_Pub"
    }
}
resource "aws_subnet" "us-east-1d-private" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
    cidr_block = "10.20.4.0/24"
  availability_zone = "${data.aws_availability_zones.azs.names[3]}"

    tags {
        Name = "us-east-1d_10.20.4.0/24_Pri"
    }
}
resource "aws_subnet" "us-east-1e-private" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
    cidr_block = "10.20.5.0/24"
  availability_zone = "${data.aws_availability_zones.azs.names[4]}"

    tags {
        Name = "us-east-1e_10.20.5.0/24_Pri"
    }
}
resource "aws_subnet" "us-east-1f-private" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
    cidr_block = "10.20.6.0/24"
  availability_zone = "${data.aws_availability_zones.azs.names[5]}"

    tags {
        Name = "us-east-1f_10.20.6.0/24_Pri"
    }
}
# Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = "${aws_vpc.IMP_vpc.id}"
  tags {
      Name = "us-east-1_10.20.0.0/24_IGW"
  }
}

#Ellastic IP
resource "aws_eip" "EIP" {
vpc = "true"
     tags {
      Name = "us-east-1f_10.20.6.0/24_EIP"
             }
         }

#Nat Gateway
resource "aws_nat_gateway" "NAT" {
    allocation_id = "${aws_eip.EIP.id}"
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    depends_on = ["aws_internet_gateway.IGW"]
    tags {
        Name = "us-east-1_10.20.0.0/24_NAT"
    }
  }

# Route Table
  resource "aws_route_table" "PublicRt" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
   route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"
      }
      tags {
            Name = "us-east-1_10.20.0.0/24_PublicRT"
      }
  }
  resource "aws_route_table" "PrivateRt" {
    vpc_id = "${aws_vpc.IMP_vpc.id}"
   route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"
      }
      tags {
            Name = "us-east-1_10.20.0.0/24_PrivateRT"
      }
  }

#Route Table Association
resource aws_main_route_table_association "MainRtPr" {
      vpc_id = "${aws_vpc.IMP_vpc.id}"
      route_table_id = "${aws_route_table.PrivateRt.id}"
            }
      resource "aws_route_table_association"  "PubRTA1" {
        subnet_id = "${aws_subnet.us-east-1a-public.id}"
        route_table_id = "${aws_route_table.PublicRt.id}"
        }
        resource "aws_route_table_association"  "PubRTA2" {
          subnet_id = "${aws_subnet.us-east-1b-public.id}"
          route_table_id = "${aws_route_table.PublicRt.id}"
          }
          resource "aws_route_table_association"  "PubRTA3" {
            subnet_id = "${aws_subnet.us-east-1c-public.id}"
            route_table_id = "${aws_route_table.PublicRt.id}"
            }
            resource "aws_route_table_association"  "PriRTA1" {
              subnet_id = "${aws_subnet.us-east-1d-private.id}"
              route_table_id = "${aws_route_table.PrivateRt.id}"
              }
              resource "aws_route_table_association"  "PriRTA2" {
                subnet_id = "${aws_subnet.us-east-1e-private.id}"
                route_table_id = "${aws_route_table.PrivateRt.id}"
                }
                resource "aws_route_table_association"  "PriRTA3" {
                  subnet_id = "${aws_subnet.us-east-1f-private.id}"
                  route_table_id = "${aws_route_table.PrivateRt.id}"
                  }
# Sec Grp
resource "aws_security_group"  "IMPsec" {
     name = "Default SG"
    description = "SG for us-east-1_10.20.0.0_VPC"
    vpc_id = "${aws_vpc.IMP_vpc.id}"
    tags {
      Name = "SG"
    }
       }
# Sec Grp rule
resource "aws_security_group_rule"  "SshIMP" {
      type = "ingress"
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = ["122.160.234.0/32"]
      security_group_id = "${aws_security_group.IMPsec.id}"
      }
resource "aws_security_group_rule" "SshSelf" {
              type = "ingress"
              from_port = "22"
              to_port = "22"
              protocol =  "tcp"
              self = "true"
              security_group_id = "${aws_security_group.IMPsec.id}"
          }
resource "aws_security_group_rule" "AllTraffic" {
              type = "egress"
              from_port = "0"
              to_port = "0"
              protocol = "-1"
              security_group_id = "${aws_security_group.IMPsec.id}"
              cidr_blocks = ["0.0.0.0/0"]
          }


    output "VPC-CIDR" {
        value = "${aws_vpc.IMP_vpc.cidr_block}"
                }
            output "SG-ID" {
              value = "${aws_security_group.IMPsec.id}"
                }
              output "us-east-1a-10.20.1.0-public_CIDR" {
                    value = "${aws_subnet.us-east-1a-public.cidr_block}"
                }
                output  "us-east-1b-10.20.2.0-public_CIDR" {
                        value = "${aws_subnet.us-east-1b-public.cidr_block}"
                    }
                    output  "us-east-1c-10.20.3.0-public_CIDR" {
                          value = "${aws_subnet.us-east-1c-public.cidr_block}"
                      }
                      output  "us-east-1d-10.20.4.0-private_CIDR" {
                            value = "${aws_subnet.us-east-1d-private.cidr_block}"
                        }
                output  "us-east-1f-10.20.6.0-private_CIDR" {
                      value = "${aws_subnet.us-east-1f-private.cidr_block}"
                  }
                  output  "us-east-1e-10.20.5.0-private_CIDR" {
                        value = "${aws_subnet.us-east-1e-private.cidr_block}"
                    }
              output  "us-east-1a-10.20.1.0-public_SubnetID" {
                  value = "${aws_subnet.us-east-1a-public.id}"
                }
              output  "us-east-1b-10.20.2.0-public_SubnetID" {
                    value = "${aws_subnet.us-east-1b-public.id}"
                }
              output  "us-east-1c-10.20.3.0-public_SubnetID" {
                    value = "${aws_subnet.us-east-1c-public.id}"
                }
              output  "us-east-1d-10.20.4.0-private_SubnetID" {
                    value = "${aws_subnet.us-east-1d-private.id}"
                }
                output  "us-east-1e-10.20.5.0-private_SubnetID" {
                      value = "${aws_subnet.us-east-1e-private.id}"
                  }
                output  "us-east-1f-10.20.6.0-private_SubnetID" {
                      value = "${aws_subnet.us-east-1f-private.id}"
                  }
                output "EIP" {
                     value = "${aws_eip.EIP.id}"
                }
