source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '~> 4.2.6'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'jquery-rails'
gem 'pnotify-rails', '~> 3.0'

gem 'sprockets', '~> 3.6.0'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'sass-rails', '~> 5.0.4'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'trix', '~> 0.9.4'
gem 'font-awesome-rails', '~> 4.5'

gem 'simple_form', '~> 3.2.1'
gem 'devise', '~> 3.5.3'
gem 'password_strength', '~> 1.1.1'
gem 'rails-i18n', '~> 4.0.0'

gem 'premailer-rails', '~> 1.9.0'

gem 'paper_trail', '~> 4.1.0'
gem 'rails_admin', '~> 0.8.1'
gem 'rails_admin_history_rollback', '~> 0.0.6'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby


# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc


gem 'unicorn'

gem 'rails_12factor', group: :production

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  gem 'capistrano-rails'
end

group :development, :test do
  # Load environment variables from .env into ENV in development.
  gem 'dotenv-rails'
end

group :test do
  # PhantomJS driver to perform acceptance tests
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
end