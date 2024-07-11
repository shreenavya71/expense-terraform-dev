#!/bin/bash
dnf install ansible -y
cd /tmp || exit 1
git clone https://github.com/shreenavya71/expense-ansible-roles.git
cd expense-ansible-roles || exit 1
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend
