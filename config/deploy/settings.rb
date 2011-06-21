#############################################################
#	Application
#############################################################

set :application, 'kazdoor'
set :deploy_to, "/home/cashbury/cashbury.com/"

#use trunk to deploy to production
  set :branch, "master"
  set :rails_env, "production"

#production
  set :domain, 'devbury.dreamhosters.com'
  role :app, domain
  role :web, domain
  role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :repository,  "git@github.com:Kazdoor/monopoly.git"
set :branch , "rajib"

#############################################################
#	Servers
#############################################################

set :user, 'cashbury'

#############################################################
#	Includes
#############################################################

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false
#before "deploy", "deploy:check_revision"
set :ssh_options, {:forward_agent => true}

#############################################################
#	Post Deploy Hooks
#############################################################

after "deploy:update_code", "deploy:write_revision"
# before "deploy:gems", "deploy:symlink"
# after "deploy:update_code", "deploy:gems"
#after "deploy:update_code", "deplspinninghats.com/current/publicoy:precache_assets" #not working for rails3 yet
