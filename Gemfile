source 'http://rubygems.org'

gem 'rails', '~> 3.1.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Asset template engines

group :assets do
    gem 'json'
    gem 'sass-rails', '~> 3.1.0'
    gem 'coffee-rails', '~> 3.1.0'
    gem 'uglifier'
    gem "compass-rails"
end

gem 'therubyracer'

gem 'jquery-rails'

gem 'acts-as-taggable-on', '~> 2.2.2'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'haml-rails'

group :production do
# Use unicorn as the web server
    gem 'unicorn'
end

# Bundle the extra gems:
gem 'RedCloth', :require => 'redcloth'
gem 'aaronh-chronic', :require => 'chronic' # Fixes for 1.9.2
gem 'coderay'
gem 'formtastic'
gem 'will_paginate', '~> 3.0'
gem 'russian'
gem 'disqus'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'factory_girl'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'hpricot'
  gem 'capistrano'
  gem 'ruby-debug19'
end

