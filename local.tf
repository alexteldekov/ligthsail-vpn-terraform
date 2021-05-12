terraform {
  backend "s3" {
    bucket = "t7g-state-files"
    key    = "terraform/lightsail-vpn"
    region = "eu-west-2"
  }
}

resource "aws_s3_bucket" "t7g-state-files" {
  bucket = "t7g-state-files"
  acl    = "private"
  versioning {
    enabled = true
  }
}

locals {
  appname = "vpn2"
  domain  = "t7g.org"
  region  = "eu-west-2"
  #  keyname  = "examplekey"
  #  pgpkey   = "keybase:exampleuser"
}
