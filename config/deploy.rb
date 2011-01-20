require "bundler/capistrano"

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
set :deploy_via, :export
set :shared_path, "/home/#{user}/.gems"

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false
ssh_options[:forward_agent] = true

set :scm, 'git'
set :repository,  "git@github.com:Kazdoor/monopoly.git"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

#############################################################
#	Post Deploy Hooks
#############################################################

after "deploy:update_code", "deploy:write_revision"
before "deploy:gems", "deploy:symlink"
#after "deploy:update_code", "deploy:gems" # You have to run deploy:gems manually after Gemfile changes
#after "deploy:update_code", "deploy:precache_assets" #not working for rails3 yet

### config/deploy/callbacks.rb
namespace :deploy do

  desc "expand the gems"
  task :gems, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; #{shared_path}/bin/bundle update"
    run "cd #{current_path}; nice -19 #{shared_path}/bin/bundle install vendor/" # nice -19 is very important otherwise DH will kill the process!
    run "cd #{current_path}; #{shared_path}/bin/bundle lock"
  end

end