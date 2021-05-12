provider "aws" {
  region = local.region
}

resource "aws_lightsail_static_ip_attachment" "app" {
  static_ip_name = aws_lightsail_static_ip.app.name
  instance_name  = aws_lightsail_instance.app.name
}

resource "aws_lightsail_static_ip" "app" {
  name = local.appname
}

resource "aws_lightsail_instance" "app" {
  name              = "${local.appname}.${local.domain}"
  availability_zone = "${local.region}a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"
  key_pair_name     = aws_lightsail_key_pair.app.name
}

resource "aws_lightsail_key_pair" "app" {
  name       = "imported"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "ip_address" {
  value = aws_lightsail_static_ip.app.ip_address
}

output "ipv6_addresses" {
  value = aws_lightsail_instance.app.ipv6_addresses
}


