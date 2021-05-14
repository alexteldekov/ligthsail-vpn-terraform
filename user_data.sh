#!/bin/sh

sudo apt-get update
sudo apt-get install -y git ansible

sed -i.bak -e 's/^127.0.0.1.*/& ${name}/' /etc/hosts
cd /root
git clone ${ansible_repo} ${ansible_role}
cd ${ansible_role}
git checkout ${ansible_branch}
cd ..

cat >hosts <<EOF
[app]
${name}

[app:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_connection=local
EOF

cat >app.yml <<EOF
- hosts: app
  roles:
    - ${ansible_role}
EOF

echo "ansible-playbook app.yml -i hosts" > run.sh
chmod +x run.sh
