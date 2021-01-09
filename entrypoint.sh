#!/bin/bash

mkdir -p ~/.ssh
chown -R root:root ~/.ssh
chmod -R 0700 ~/.ssh
cp -ip /run/secrets/ec2_ssh_key ~/.ssh/ec2_rsa
cp -ip /run/secrets/git_hub_ssh_key ~/.ssh/id_rsa
chmod -R 0400 ~/.ssh/ec2_rsa
chmod -R 0600 ~/.ssh

exec "$@"
