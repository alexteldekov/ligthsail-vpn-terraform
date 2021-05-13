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
  #user_data         = file("user_data.sh")
  user_data         = templatefile("${path.module}/user_data.sh", { name = self.name })
}

resource "aws_lightsail_key_pair" "app" {
  name       = "imported"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_lightsail_instance_public_ports" "app" {
  instance_name = aws_lightsail_instance.app.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 6022
    to_port   = 6022
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }

  port_info {
    protocol  = "udp"
    from_port = 500
    to_port   = 500
  }

  port_info {
    protocol  = "udp"
    from_port = 4500
    to_port   = 4500
  }

  port_info { # ping
    protocol  = "icmp"
    from_port = 8
    to_port   = 0
  }
}

output "ip_address" {
  value = aws_lightsail_static_ip.app.ip_address
}

output "ipv6_addresses" {
  value = aws_lightsail_instance.app.ipv6_addresses
}


