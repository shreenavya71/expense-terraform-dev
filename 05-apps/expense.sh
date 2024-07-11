#!/bin/bash
dnf install ansible -y
cd /tmp || exit
git clone https://github.com/shreenavya71/expense-ansible-roles.git
cd expense-ansible-roles || exit
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend
