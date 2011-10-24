require 'yaml'
# Load the rails application
require File.expand_path('../application', __FILE__)
YAML::ENGINE.yamler= 'syck'
Encoding.default_internal = 'UTF-8'
# Initialize the rails application
Isbnnetin::Application.initialize!


