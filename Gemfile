source 'http://rubygems.org'

gem 'rails'
gem 'jquery-rails'

# http://mongoid.org/docs/installation/
gem 'mongoid'
gem 'bson_ext'

gem 'delayed_job'
gem 'delayed_job_mongoid'

gem 'dalli'

gem 'configatron', :require => 'configatron' # https://github.com/markbates/configatron/

gem 'mechanize', :require => 'mechanize'
gem 'amazon-ecs', :require => 'amazon/ecs'


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)

#gem 'ruby-debug'
#gem 'ruby-debug19'
# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'wirble'
  gem 'hirb'
  gem 'awesome_print'
  gem 'gemedit'
 if RUBY_VERSION =~ /1.9/
    gem 'ruby-debug19'
 else
    gem 'ruby-debug'
 end
end
