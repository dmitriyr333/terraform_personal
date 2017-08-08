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


# modules
module "create_instances" {
  source   = "../modules/aws/instances"
  ami      = "${var.ami}"
  key_name = "${var.key_name}"
}


# resources
resource "aws_eip" "ip" {
  instance = "${module.create_instances.publicIP}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "allow ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_ssh"
  }
}


# outputs
output "ip" {
  value = "${aws_eip.ip.public_ip}"
}