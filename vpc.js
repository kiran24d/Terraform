let aws = {};
let EC2 = {};
let ec2 = {};
let AWS = {};
let reg = "us-east-1";
let subnetazs = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f","us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f"];
let cb = "10.20.0.0"; 
let azs = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f","us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f"];

tf = {};
tf.terraform = {};

let t = tf.terraform;
t.provider = {};
t.resource = {};

t.provider.aws = { region : `${reg} `};
let r = t.resource;
r.aws_internet_gateway = {};

r.aws_vpc = {};
let vpc = r.aws_vpc;
vpc.IMP_Vpc = {
    cidr_block : `${cb}/16`,
    enable_dns_support : true,
    enable_dns_hostnames : true }
vpc.IMP_Vpc.tags = { Name : 'Imp_Vpc'};

let IG = r.aws_internet_gateway = {};
IG.Igw_Imp = { vpc_id : 'IMP_Vpc' }
  IG.Igw_Imp.tags = { Name : "us-east-1_10.20.0.0/24_IMP_IG" };

r.aws_instance = {};
const fs = require('fs')
let instance = r.aws_instance = {};
instance.Web = {
    ami : "ami-0922553b7b0369273",
    count : "1",instance_type : "t2.medium",
    subnet_id : "0",
    key_name : "IMP",
    associate_public_ip_address : true,
    security_groups : ["default"],
    UserData: fs.readFileSync('./user-data.sh', 'base64'),
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
            vpc_id : 'IMP_Vpc',
            cidr_block : `10.20.${s+1}.0/24,
            availability_zone : subnetazs[s]  };
        subnet[s].tags = { Name : `${subnet_type}-${subnetazs[s]}`};
            };
    for (let n = 6, subnet_type = "Private"; n < azs.length; n++) {
        if (n <= 11 ) {
                    subnet_type = "Private"; }
                    subnet[n] = {
                    vpc_id : 'IMP_Vpc',
                    cidr_block : `10.20.${s+1}.0/24,
                    availability_zone : subnetazs[n]
                };
                subnet[n].tags = {
                    Name : `${subnet_type}-${subnetazs[n]}`
                };
                    };
    let NODE = JSON.stringify(tf, null, 2);
    console.log(NODE);
    const { writeFileSync } = require('fs');
    writeFileSync('./template.tf.json', NODE);
