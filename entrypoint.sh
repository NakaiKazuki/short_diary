#!/bin/bash

mkdir -p ~/.ssh
chown -R root:root ~/.ssh
chmod -R 700 ~/.ssh
cp -ip /run/secrets/ec2_key ~/.ssh/ec2_key_rsa
cp -ip /run/secrets/git_key ~/.ssh/git_rsa
chmod -R 400 ~/.ssh/ec2_key_rsa
chmod -R 400 ~/.ssh/git_rsa

exec "$@"
