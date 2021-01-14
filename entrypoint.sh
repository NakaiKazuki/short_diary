#!/bin/bash

mkdir -p ~/.ssh
chown -R root:root ~/.ssh
chmod -R 700 ~/.ssh
cp -ip /run/secrets/ec2_rsa ~/.ssh/ec2_rsa
cp -ip /run/secrets/git_rsa ~/.ssh/git_rsa
chmod -R 400 ~/.ssh/ec2_rsa
chmod -R 400 ~/.ssh/git_rsa

exec "$@"
