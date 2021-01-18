set :rails_env, :production

server Rails.application.credentials.amazon.dig(:amazon, :ec2_ip),
       user: Rails.application.credentials.dig(:amazon, :ec2_user),
       roles: %w[web app db]

set :deploy_to, '/var/www/rails/short_diary'

set :ssh_options, {
  keys: %w[~/.ssh/id_rsa_6c6771c3ae79b9dead5b89c1c155775f],
  forward_agent: true
}
