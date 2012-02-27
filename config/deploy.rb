# RVM bootstrap
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2-p290'

# bundler bootstrap
require 'bundler/capistrano'

# Multistage
set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# main details
set :application, "cashnode.cashbury.com"
set :domain, application
role :web, domain   # Your HTTP server, Apache/etc
role :app, domain   # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/var/www/apps/#{domain}"
set :deploy_via, :remote_cache
set :user, "passenger"
set :use_sudo, false

# repo details
set :scm, :git
#set :scm_username, "amer"
set :repository, "git@github.com:Kazdoor/monopoly.git"
set :branch, "demo2"
set :git_enable_submodules, 1

# Passenger
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do ; end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
