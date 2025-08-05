resource "aws_instance" "Jenkins" {
  ami                    = var.amiID[var.region]
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.Jenkins.key_name
  availability_zone      = var.zone
  vpc_security_group_ids = [aws_security_group.Jenkins.id]
  count                  = 1
  
  root_block_device {
    volume_type = "gp3"
    volume_size = 30
    encrypted   = true
  }
  
  tags = {
    Name    = "Jenkins"
    Project = "Infrastructure"
  }
}
resource "aws_ec2_instance_state" "web_state" {
  count       = length(aws_instance.Jenkins)
  instance_id = aws_instance.Jenkins[count.index].id
  state       = "running"
}