# require "bundler/capistrano"

set :user, 'kazdoor'  # Your dreamhost account's username
set :domain, 'ps41154.dreamhostps.com'  # Dreamhost servername where your account is located 
set :project, 'spinninghats.com'  # Your application as its called in the repository
set :application, 'spinninghats.com'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache
set :shared_path, "/home/#{user}/.gems"

set :scm, 'git'
set :repository,  "git@github.com:Kazdoor/monopoly.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false
ssh_options[:forward_agent] = true

#############################################################
#	Post Deploy Hooks
#############################################################

# after "deploy:update_code", "deploy:write_revision"
# before "deploy:gems", "deploy:symlink"
#after "deploy:update_code", "deploy:gems" # You have to run deploy:gems manually after Gemfile changes
#after "deploy:update_code", "deploy:precache_assets" #not working for rails3 yet

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'