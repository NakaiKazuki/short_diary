#!/bin/bash

mkdir -p ~/.ssh
chown -R root:root ~/.ssh
chmod -R 700 ~/.ssh
cp -ip /run/secrets/ec2_ssh_key ~/.ssh/short_diary_key_rsa
cp -ip /run/secrets/git_hub_ssh_key ~/.ssh/id_rsa
chmod -R 600 ~/.ssh/id_rsa
chmod -R 400 ~/.ssh/short_diary_key_rsa
chmod -R 700 ~/.ssh
# これを自動で行うようにする
# eval `ssh-agent`
#
# ssh-add ~/.ssh/id_rsa

exec "$@"
