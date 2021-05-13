#!/bin/sh

sudo apt-get update
sudo apt-get install -y git ansible

sed -i.bak -e 's/^127.0.0.1.*/& vpn.t7g.org/' /etc/hosts
cd /root
git clone https://github.com/alexteldekov/vpn-server.git

cat >hosts <<EOF
[vpn]
vpn.t7g.org

[vpn:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_connection=local
EOF

cat >vpn-server.yml <<EOF
- hosts: vpn
  roles:
    - vpn-server
EOF

echo "ansible-playbook vpn-server.yml -i hosts" > run.sh
chmod +x run.sh
