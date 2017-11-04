# config valid only for current version of Capistrano
lock "3.9.1"

set :application, "zozotown"
set :repo_url, "git@github.com:meishinchu/zozotown.git"

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['/Users/meiko/.ssh/zozo_key_pair.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

# desc "Stop unicorn server gracefully"
# task stop: :environment do
#   on roles(:app) do
#     execute :kill, "-s QUIT $(< #{fetch(:unicorn_pid)})"
#   end
# end

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    execute :kill, "-s QUIT $(< #{fetch(:unicorn_pid)})"
    invoke 'unicorn:restart'
  end
end
