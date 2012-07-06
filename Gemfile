source 'http://rubygems.org'

gem 'rails'
gem 'jquery-rails'
gem 'rake', '~> 0.8.7'
# http://mongoid.org/docs/installation/
gem 'mongoid'
gem 'bson','1.6.2'
gem 'bson_ext','1.6.2'
gem 'mongo_mapper'
gem 'dalli'
gem 'configatron', :require => 'configatron' # https://github.com/markbates/configatron/
gem 'jammit'
gem 'mechanize', :require => 'mechanize'
gem 'amazon-ecs', :require => 'amazon/ecs'
gem 'amatch'
gem 'typhoeus'
gem 'vss'
gem "SystemTimer", :require => "system_timer", :platforms => :ruby_18
gem "rack-timeout"
gem "tweet-button"
gem 'sitemap_generator'
gem 'nokogiri'
gem 'execjs'
gem 'therubyracer'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'wirble'
  gem 'hirb'
  gem 'awesome_print'
  gem 'gemedit'
  gem 'capistrano'
  gem 'rvm-capistrano'
 # if RUBY_VERSION =~ /1.9/
    #gem 'ruby-debug19'
 #else
 #   gem 'ruby-debug'
 #end
end
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end
