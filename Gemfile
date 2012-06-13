source 'https://rubygems.org'

ruby_1_8 = RUBY_VERSION.match(/^1\.8/)
ruby_1_9 = RUBY_VERSION.match(/^1\.9/)

group :development do
  gem 'ruby-debug' if ruby_1_8
end

group  :test do
  gem 'sinatra'
  gem 'rspec'
  gem 'pry'
  gem 'hpricot'
  gem 'haml'
  gem 'simplecov', :require => false if ruby_1_9
end

# Specify your gem's dependencies in syma.gemspec
gemspec
