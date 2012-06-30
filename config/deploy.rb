# RVM bootstrap
#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) 
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2-p290'
set :rvm_type, :system
# bundler bootstrap
require 'bundler/capistrano'

# Delayed_jobs
require "delayed/recipes"
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

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
set :branch, "master"
set :git_enable_submodules, 1

# More configurations
set :keep_releases, 3 # When deploy:cleanup keep just 3 releases. Defult is 5
set :use_sudo, false  # Please stay save.

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


require 'yaml'

desc "Backup the remote production database"
task :backup, :roles => :db, :only => { :primary => true } do
  db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), 'database.yml'))).result)["#{rails_env}"]
  release_name = current_release.split("/").last
  filename = "#{release_name}.#{application}.#{rails_env}.#{db['database']}.`date +'%F.%H-%M-%S'`.sql.bz2"
  backup_dir =  "~/database_backups"
  run("mkdir -p #{backup_dir}")
  file = "#{backup_dir}/#{filename}"
  run "mysqldump -u #{db['username']} --password=#{db['password']} #{db['database']} | bzip2 -c > #{file}"  do |ch, stream, data|
    puts data
  end
end

before ["deploy:migrate","deploy:migrations"], "backup"
