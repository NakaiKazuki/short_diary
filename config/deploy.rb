require File.expand_path('./environment', __dir__)
# config valid for current version and patch releases of Capistrano
lock '~> 3.15.0'
# アプリケーション名
set :application, 'short_diary'
# githubのurl。プロジェクトのgitホスティング先を指定する
set :repo_url, 'git@github.com:NakaiKazuki/short_diary.git'
# デプロイ先のサーバーのディレクトリ。フルパスで指定
set :deploy_to, '/var/www/rails/short_diary'

# Rubyのバージョンを指定
set :rbenv_ruby, '2.7.2'

# シンボリックリンクのファイルを指定、具体的にはsharedに入るファイル
append :linked_files, 'config/master.key'
# シンボリックリンクのディレクトリを生成
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'
# タスクでsudoを行う際に必要
set :pty, true
# 保持するバージョンの個数
set :keep_releases, 3
# 出力するログのレベル。
set :log_level, :debug

# puma
set :puma_init_active_record, true

# Nginxの設定ファイル名と置き場所を修正
set :nginx_sites_enabled_path, '/etc/nginx/conf.d'
set :nginx_config_name, "#{fetch(:application)}.conf"
