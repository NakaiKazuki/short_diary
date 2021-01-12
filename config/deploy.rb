# config valid for current version and patch releases of Capistrano
lock '~> 3.15.0'
# アプリケーション名
set :application, 'short_diary'
# githubのurl。プロジェクトのgitホスティング先を指定する
set :repo_url, 'https://github.com/NakaiKazuki/short_diary.git'
# デプロイ先のサーバーのディレクトリ。フルパスで指定
set :deploy_to, '/var/www/rails/short_diary'

set :rbenv_type, :user
set :rbenv_ruby, '2.7.2'

# シンボリックリンクのファイルを指定、具体的にはsharedに入るファイル
append :linked_files, "config/master.key"
# シンボリックリンクのディレクトリを生成
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads", "public/storage"
# タスクでsudoなどを行う際に必要
set :pty, true
# 保持するバージョンの個数(※後述)
set :keep_releases, 3
# 出力するログのレベル。
set :log_level, :debug

namespace :deploy do
  desc 'Create database'
  task :db_create do
    on roles(:db) do |_host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'Restart application'
  task :puma_restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke  'puma:stop'
      invoke! 'puma:start'
    end
  end
end
after 'deploy:finishing', 'deploy:puma_restart'
