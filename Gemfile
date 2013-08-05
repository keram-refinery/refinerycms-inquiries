source 'https://rubygems.org'

gemspec

gem 'refinerycms', :path => '../' # , :git => 'git://github.com/refinery/refinerycms.git'
gem 'refinerycms-i18n', :path => '../' # , :git => 'git://github.com/refinery/refinerycms-i18n.git'

gem 'rails', '~> 4.0.0'
gem 'railties', '~> 4.0.0'
gem 'devise', :path => '../devise' #:git => 'git://github.com/plataformatec/devise.git', :branch => 'rails4'
gem 'decorators', :path => '../decorators'
gem 'database_cleaner', :path => '../database_cleaner'

gem 'globalize3', :path => '../globalize3'
gem 'friendly_id', :path => '../friendly_id'
gem 'filters_spam', :path => '../filters_spam'

group :development, :test do
  gem 'guard-rspec', '~> 3.0.2'
  gem 'capybara-email', '~> 2.1.2'
end

gem 'quiet_assets', :group => :development

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
  gem 'sqlite3', :platform => :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
  gem 'activerecord-jdbcmysql-adapter', :platform => :jruby
  gem 'jdbc-mysql', '= 5.1.13', :platform => :jruby
  gem 'mysql2', :platform => :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'postgresql'
  gem 'activerecord-jdbcpostgresql-adapter', :platform => :jruby
  gem 'pg', :platform => :ruby
end

gem 'jruby-openssl', :platform => :jruby

group :test do
  gem 'refinerycms-testing', '~> 3.0.0.dev'
  gem 'generator_spec', '~> 0.9.0'
end

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier'

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
