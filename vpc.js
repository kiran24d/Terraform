let reg = "us-east-1";
let cb = "10.20.0.0"; 
let azs = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f","us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f"];
let subnetazs = [];
    for (let m = azs.length; subnetazs.length < 11; m++) {
        subnetazs = subnetazs.concat(azs);
    };
tf = {};
tf.terraform = {};

let t = tf.terraform;
t.provider = {};
t.resource = {};

let aws = {};
t.provider.aws = { region : `${reg} `,
access_key : {},
secret_key : {}
};
let r = t.resource;
r.aws_internet_gateway = {};

r.aws_vpc = {};
let vpc = r.aws_vpc;
vpc.IMP_Vpc = {
    cidr_block : `${cb}/16`,
    enable_dns_support : true,
    enable_dns_hostnames : true }
vpc.IMP_Vpc.tags = { Name : 'Imp_Vpc'};

let SG = r.aws_default_security_group = {};
SG.default = { vpc_id : '${aws_vpc.IMP_Vpc.id}',
ingress :{
    protocol  : -1,
    self      : true,
    from_port : 0,
    to_port   : 0
  }
};
let IG = r.aws_internet_gateway = {};
IG.Igw_Imp = { vpc_id : '${aws_vpc.IMP_Vpc.id}' }
  IG.Igw_Imp.tags = { Name : "us-east-1_10.20.0.0/24_IMP_IG" };

r.aws_instance = {};
const fs = require('fs')
let instance = r.aws_instance = {};
instance.Web = {
    ami : "ami-0922553b7b0369273",
    count : "1",instance_type : "t2.medium",
    subnet_id : '${aws_subnet.0.id}',
    key_name : "IMP",
    associate_public_ip_address : true,
    security_groups : ["default"],
    root_block_device : {delete_on_termination : true, 
    volume_size : "50",
    volume_type : "gp2" }
}
instance.Web.tags = {Name : 'Web'};
    
    r.aws_subnet = {};

let subnet = r.aws_subnet;
    for (let s = 0, subnet_type = "Public"; s < azs.length; s++) {
        if (s >= 5 ) {subnet_type = "Public";
            }
            subnet[s] = {
            vpc_id : '${aws_vpc.IMP_Vpc.id}',
            cidr_block : `10.20.${s+1}.0/24`,
            availability_zone : subnetazs[s]
            };  
        subnet[s].tags = { Name : `${subnet_type}-${subnetazs[s]}`};
            };
    for (let n = 6, subnet_type = "Private"; n > azs.length; n++) {
        if (n <= 11 ) {
                    subnet_type = "Private"; }
                    subnet[n] = {
                    vpc_id : '${aws_vpc.IMP_Vpc.id}',
                    cidr_block : `10.20.${n+1}.0/24`,
                    availability_zone : subnetazs[s]
                };
                subnet[n].tags = {
                    Name : `${subnet_type}-${subnetazs[n]}`
                };
                    };
    let NODE = JSON.stringify(tf, null,3);
    console.log(NODE);
    const { writeFileSync } = require('fs');
    writeFileSync('./template.tf.json', NODE);
