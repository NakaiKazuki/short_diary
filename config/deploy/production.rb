set :rails_env, :production

server Rails.application.credentials.amazon.dig(:amazon, :ec2_ip),
       user: Rails.application.credentials.dig(:amazon, :ec2_user),
       roles: %w[web app db]

set :deploy_to, '/var/www/rails/short_diary'

set :ssh_options, {
  keys: [ENV.fetch('EC2_SSH_KEY').to_s],
  forward_agent: true
}
