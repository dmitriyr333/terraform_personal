# init variables
variable "region" {}
variable "ami" {}
variable "key_name" {}
variable "param_name" {}
variable "param_store_key" {}
variable "database_master_password" {}

variable "cidrs" {
  type = "list"
  default = []
}



# providers
provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "/Users/dmitriyrozentsvay/.aws/credentials"
  profile                 = "personal"
}

resource "aws_instance" "ubuntu" {
  # depends_on    = ["aws_security_group.allow_ssh"]
  # security_groups = ["${aws_security_group.allow_ssh.name}"]
  instance_type = "t2.micro"
  ami = "${var.ami}"
  tags {
    Name = "${var.param_name}"
  }
  key_name = "${var.key_name}"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "ssh into ec2"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    name = "allow_ssh"
  }
}
# # modules
# module "create_instances" {
#   source   = "../modules"
#   ami      = "${var.ami}"
#   key_name = "${var.key_name}"
# }

resource "aws_eip" "ip" {
  instance = "${aws_instance.ubuntu.id}"
}

data "aws_iam_policy_document" "access_to_ssm_params" {
  statement {
    actions = [ 
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/${var.param_name}.*",
    ]
  }
  statement {
    actions = [ 
      "kms:Describe*",
      "kms:Decrypt",
      "kms:ListKeys",
      "kms:ListAliases",
    ]
    resources = [
      "${var.param_store_key}",
    ]
  }
}

# resource "aws_iam_role" "ubuntu_role" {
#   name = "ubuntu_role"
#   path = "/"
#   policy = "${data.aws_iam_policy_document.access_to_ssm_params.json}"
# }


resource "aws_ssm_parameter" "secret_db_pwd" {
  # name  = "database/password/master"
  name  = "database"
  type  = "SecureString"
  value = "${var.database_master_password}"
}

resource "aws_ssm_parameter" "secret_db_user" {
  # name  = "database/password/master"
  name  = "database"
  type  = "String"
  value = "some_userdb"
}


output "eip_ip" {
  value = "${aws_eip.ip.ubuntu.public_ip}"
}
