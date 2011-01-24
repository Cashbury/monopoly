namespace :deploy do

# this can probably be done better once bundler is updated or you can lock before deploying
# but I really like the way bundler 0.8.1 just updated the gems on the fly from the cache
# I also really don't like deploying all my gems in the system directory, since you can run into
# really messy version conflicts. Keep the gems with the app that needs them, and your system gems clean

  # desc "expand the gems"
  # task :gems, :roles => :web, :except => { :no_release => true } do
  #   run "cd #{current_path}; #{shared_path}/bin/bundle unlock"
  #   run "cd #{current_path}; #{shared_path}/bin/bundle install vendor/"
  #   run "cd #{current_path}; #{shared_path}/bin/bundle lock"
  # end

  # desc 'Bundle and minify the JS and CSS files'
  # task :precache_assets, :roles => :app do
  #   root_path = File.expand_path(File.dirname(__FILE__) + '/../..')
  #   assets_path = "#{root_path}/public/assets"
  #   # run_locally "#{root_path}/vendor/bin/jammit"
  #   top.upload assets_path, "#{current_path}/public", :via => :scp, :recursive => true
  # end

end