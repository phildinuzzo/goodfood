# Load the rails application
require File.expand_path('../application', __FILE__)
YAML.load_file("#{::Rails.root}/config/api_keys.yml")[::Rails.env].each {|k,v| ENV[k]=v}
# Initialize the rails application
Goodfood::Application.initialize!
