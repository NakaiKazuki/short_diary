#!/bin/bash

mkdir -p ~/.ssh
chown -R root:root ~/.ssh
chmod -R 700 ~/.ssh
cp -ip /run/secrets/ec2_ssh_key ~/.ssh/short_diary_key_rsa
cp -ip /run/secrets/git_hub_ssh_key ~/.ssh/ec2_git_rsa
chmod -R 600 ~/.ssh/ec2_git_rsa
chmod -R 400 ~/.ssh/short_diary_key_rsa
# これを自動で行うようにする or Capistranoのファイルで読み取らせる のが課題
# eval `ssh-agent`
#
# ssh-add ~/.ssh/ec2_git_rsa

exec "$@"
