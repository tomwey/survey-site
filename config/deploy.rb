# coding: utf-8
require "bundler/capistrano"

server "112.124.48.51", :web, :app, :db, primary: true

set :application, "survey-site"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git@github.com:tomwey/#{application}.git"
set :branch, "master"

# 将上传文件的目录加到shared_path，并链接到release_path下
set :shared_children, shared_children + %w{public/uploads}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# 保留5个最新的版本
after "deploy", "deploy:cleanup"
# after "deploy:cleanup", "deploy:remote_rake"

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
  
  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    put File.read("config/config.yml.example"), "#{shared_path}/config/config.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"
  
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
  
end

namespace :remote_rake do
  task :create do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:create"
  end
  task :migrate do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:migrate"
  end
  task :seed do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:seed"
  end
  task :drop do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:drop"
  end
end
