# init variables
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "ami" {}
variable "key_name" {}
variable "param_name" {}
variable "param_store_key" {}

variable "cidrs" {
  type = "list"
  default = []
}



# providers
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
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
# # modules
# module "create_instances" {
#   source   = "../modules"
#   ami      = "${var.ami}"
#   key_name = "${var.key_name}"
# }

# resource "aws_eip" "ip" {
#   instance = "${aws_instance.ubuntu.id}"
# }

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


data "aws_ssm_parameter" "website" {
  name  = "WEBSITE.someOrOtherSecret"
}


# output "eip_ip" {
#   value = "${aws_eip.ip.ubuntu.public_ip}"
# }