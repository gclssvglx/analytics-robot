source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "7.0.3.1"

gem "bootsnap", require: false
gem "capybara"
gem "dartsass-rails"
gem "govuk_app_config"
gem "govuk_sidekiq"
gem "importmap-rails"
gem "jbuilder"
gem "redis"
gem "sassc-rails"
gem "selenium-webdriver"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "webdrivers"

group :test do
  gem "simplecov"
end

group :development, :test do
  gem "byebug"
  gem "govuk_test"
  gem "rspec-rails"
  gem "rubocop-govuk"
end

group :development do
  gem "web-console"
end
