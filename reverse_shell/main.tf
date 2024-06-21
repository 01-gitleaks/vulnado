provider "aws"  {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "tmp_vulnado_rev_shell_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "tmp_vulnado_rev_shell_igw"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "tmp_vulnado_rev_shell_rt"
  }
}



resource "aws_route_table_association" "assoc" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.r.id}"
}



data "aws_ami" "amznlinux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20181114-x86_64-gp2"]

  }
}


resource "aws_key_pair" "attacker" {
  key_name   = "tmp-vulnado-deploy-key"
  public_key = "${var.public_key}"
}
