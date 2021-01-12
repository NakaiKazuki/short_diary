set :rails_env, :production
server '52.193.58.137', user: 'Kazuki', roles: %w[web app db]
set :deploy_to, '/var/www/rails/short_diary'

set :ssh_options, {
  keys: %w[~/.ssh/short_diary_key_rsa],
  forward_agent: true
}

# # ソケットの場所、Nginxとのやり取りに必要
# set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
# # サーバー状態を表すファイルの場所
# set :puma_state, "#{shared_path}/tmp/pids/puma.state"
# # プロセスを表すファイルの場所
# set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
# # ログの場所
# set :puma_access_log, "#{shared_path}/log/puma.error.log"
# set :puma_error_log, "#{shared_path}/log/puma.access.log"
# # puma
# set :puma_init_active_record, true
