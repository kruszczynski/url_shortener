source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-param', require: 'sinatra/param'

# couchrest model does not support rails 4.2
# This most likely will be fixed by
# a couchrest_model update
gem 'activemodel', '4.1.14.1'
gem 'couchrest_model'

gem 'etcd'

group :development, :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'rubocop'
  gem 'reek'
  gem 'factory_girl'
end
