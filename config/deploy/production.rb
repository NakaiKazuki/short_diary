set :rails_env, :production
server '52.193.58.137', user: 'Kazuki', roles: %w[web app db]
set :deploy_to, '/var/www/rails/short_diary'

set :ssh_options, {
  keys: %w[~/.ssh/short_diary_key_rsa],
  forward_agent: true
}
