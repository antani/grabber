# RVM

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_bin_path, "/usr/local/bin"
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user

#set :default_environment, {
#  'PATH' => "/root/.rbenv/shims:/root/.rbenv/bin:$PATH"

#}


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
 
after 'deploy:update_code', 'bundler:bundle_new_release'
