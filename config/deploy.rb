# RVM

#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
#set :rvm_bin_path, "/root/.rvm/bin"
#set :rvm_bin_path, "/usr/local/bin"
#set :rvm_bin_path, "$HOME/bin"
set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_ruby_string, 'default'
set :rvm_type, :system

#set :rvm_type, :system
#set :default_environment, {
#  'PATH' => "/root/.rbenv/shims:/root/.rbenv/bin:$PATH"

#}
#set :rvm_bin_path, "/usr/local/bin"

# Bundler

require "bundler/capistrano"

# General

set :application, "grabber"
set :user, "passenger"

set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy

set :use_sudo, false

# Git

set :scm, :git
set :repository, "git://github.com/antani/grabber.git"
#set :repository,  "~/#{application}/.git"
set :branch, "master"
set :scm_passphrase, "m0rpheus"

# VPS

role :web, "46.102.244.155"
role :app, "46.102.244.155"
role :db,  "46.102.244.155", :primary => true
role :db,  "46.102.244.155"

# Passenger

namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end
namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without development:test"
  end
end
 
#after 'deploy:update_code', 'bundler:bundle_new_release'

after "deploy", "refresh_sitemaps"
task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=production bundle exec rake sitemap:refresh"
end
after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
end