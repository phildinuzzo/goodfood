# Load the rails application
YAML.load_file("#{::Rails.root}/config/api_keys.yml")[::Rails.env].each {|k,v| ENV[k]=v}
require File.expand_path('../application', __FILE__)
# Initialize the rails application
Goodfood::Application.initialize!
