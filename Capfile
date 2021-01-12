require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'sshkit/sudo'
require 'capistrano/scm/git'
require 'capistrano/puma'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Nginx

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
