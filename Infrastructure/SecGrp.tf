resource "aws_security_group" "Jenkins" {
  name        = "Jenkins"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  security_group_id = aws_security_group.Jenkins.id
  cidr_ipv4         = "122.161.52.201/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "Jenkins-Port" {
  security_group_id = aws_security_group.Jenkins.id
  cidr_ipv4         = "122.161.52.201/32"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.Jenkins.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.Jenkins.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}