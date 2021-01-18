set :rails_env, :production

server Rails.application.credentials.dig(:amazon, :ec2_ip),
       user: Rails.application.credentials.dig(:amazon, :ec2_user),
       roles: %w[web app db]

set :deploy_to, '/var/www/rails/short_diary'

set :ssh_options, {
  keys: %w[~/.ssh/short_diary_key_rsa],
  forward_agent: true
}

# デプロイ時はssh-agent追加する
# eval `ssh-agent` && ssh-add ~/.ssh/git_rsa
