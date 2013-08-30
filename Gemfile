source 'https://rubygems.org'

gemspec

gem 'refinerycms', '~> 3.0.0.dev', github: 'keram-refinery/refinerycms', branch: 'refinery_light', group: :test
gem 'refinerycms-settings', '~> 3.0.0.dev', github: 'keram-refinery/refinerycms-settings', branch: 'refinery_light'
gem 'refinerycms-i18n', '~> 3.0.0.dev', github: 'keram-refinery/refinerycms-i18n', branch: 'refinery_light'
gem 'refinerycms-testing', '~> 3.0.0.dev', group: :test

group :development, :test do
  gem 'guard-rspec', '~> 3.0.2'
  gem 'capybara-email', '~> 2.1.2'
end

gem 'quiet_assets', group: :development

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', platform: :jruby
  gem 'sqlite3', platform: :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
  gem 'activerecord-jdbcmysql-adapter', platform: :jruby
  gem 'jdbc-mysql', '= 5.1.13', platform: :jruby
  gem 'mysql2', platform: :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'postgresql'
  gem 'activerecord-jdbcpostgresql-adapter', platform: :jruby
  gem 'pg', platform: :ruby
end

gem 'jruby-openssl', platform: :jruby

group :test do
  gem 'generator_spec', '~> 0.9.0'
end

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier'

gem 'turbolinks'

gem 'jquery-rails', '~> 3.0.4'
gem 'jquery-ui-rails', '~> 4.0.4'


# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
