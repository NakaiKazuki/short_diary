server Rails.application.credentials.dig(:amazon, :ec2_ip),
       user: Rails.application.credentials.dig(:amazon, :ec2_user),
       roles: %w[web app db]

set :ssh_options, {
  keys: (ENV['PRODUCTION_SSH_KEY']),
  forward_agent: true
}
