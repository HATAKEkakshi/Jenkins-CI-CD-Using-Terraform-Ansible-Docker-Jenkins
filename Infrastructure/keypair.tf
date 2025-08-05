resource "aws_key_pair" "Jenkins" {
  key_name   = "Jenkins-key"
  public_key = file("jenkinscicd.pem.pub")
}