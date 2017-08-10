# init variables
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "ami" {}
variable "key_name" {}

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
    Name = "terraforming"
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


# resource "aws_iam_role" "ubuntu_role" {
#   name = "ubuntu_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "ssm:GetParameters",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Resource": "arn:aws:ssm:*:*:parameter/ubuntu.*"
      
#     }
#   ]
# }
# EOF
# }

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# output "eip_ip" {
#   value = "${aws_eip.ip.ubuntu.public_ip}"
# }
