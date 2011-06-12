# symlinks are setup for bundler deploy, and are based on 0.8.1 version
# of being able to bundle from the cache. right now it's re-deploying
# everything. I'd like to get this fixed at some point

namespace :deploy do
  desc "Make all the symlinks"
  task :symlink, :roles => :app, :except => { :no_release => true } do
    set :normal_symlinks, %w(public/system config/database.yml log)

    commands = normal_symlinks.map do |path|
      "rm -rf #{current_path}/#{path} && ln -s #{shared_path}/#{path} #{current_path}/#{path}"
    end

    set :weird_symlinks, {
      "#{shared_path}/bin" => "vendor/bin",
      "#{shared_path}/specifications" => "vendor/specifications",
      "#{shared_path}/gems" => "vendor/gems",
      "#{shared_path}/doc" => "vendor/doc"
    }

    commands += weird_symlinks.map do |from, to|
      "rm -rf #{current_path}/#{to} && ln -s #{from} #{current_path}/#{to}"
    end

    # needed for some of the symlinks
    run "mkdir -p #{current_path}/tmp && mkdir -p #{current_path}/config"
    run "cd #{current_path} && #{commands.join(' && ')}"
  end
end