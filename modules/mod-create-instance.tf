# creating instances
variable ami {}
variable key_name {}


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


output "publicIP" {
  value = "${aws_instance.ubuntu.ip}"
}