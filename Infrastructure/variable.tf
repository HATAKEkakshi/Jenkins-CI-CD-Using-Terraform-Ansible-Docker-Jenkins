variable "region" {
  description = "Region to deploy resources in"
  default     = "us-east-1"
}
variable "amiID" {
  type        = map(any)
  description = "value of amiID"
  default = {
    "us-east-1" = "ami-020cba7c55df1f615"
    "us-east-2" = "ami-058a8a5ab36292159"
  }
}
variable "zone" {
  description = "Availability zone to deploy resources in"
  default     = "us-east-1a"
}
variable "webuser" {
  default = "ubuntu"
}