server '52.193.58.137', user: 'Kazuki', roles: %w[web app db]

set :ssh_options, keys: '~/.ssh/ec2_rsa'
