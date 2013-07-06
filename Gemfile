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

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier'

# for dummy
gem 'turbolinks', :path => '../turbolinks'

gem 'jquery-rails', '~> 3.0.1'
gem 'jquery-ui-rails', '~> 4.0.2'

gem 'will_paginate'

group :development, :test do
  gem 'refinerycms-testing', :path => '../refinerycms/' # , :git => 'git://github.com/refinery/refinerycms.git'
  gem 'guard-rspec', '~> 3.0.2'
  gem 'capybara-email', '~> 2.1.2'

  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'activerecord-jdbcmysql-adapter'
    gem 'activerecord-jdbcpostgresql-adapter'
    gem 'jruby-openssl'
  end

  unless defined?(JRUBY_VERSION)
    gem 'sqlite3'
    gem 'mysql2'
    gem 'pg'
  end

  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    unless ENV['TRAVIS']
      require 'rbconfig'
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '>= 0.3.9'
        gem 'ruby_gntp'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '~> 0.9.0'
        gem 'libnotify',  '~> 0.8.1'
        gem 'therubyracer', '~> 0.11.4'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      require 'rbconfig'
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'ruby_gntp'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '~> 0.9.0'
        gem 'libnotify', '~> 0.8.1'
      end
    end
  end
end
