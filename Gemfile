source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Rails Core
gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "rails-i18n", "7.0.5"
gem "puma", "~> 5.0"
gem "good_job", "~> 3.20.0"

# Assets
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

# Database (Model)
gem "pg"
gem "validate_url", "~> 1.0.15"

# HTTP Client
gem "faraday", "~> 2.6.0"
gem "faraday-retry", "~> 2.0.0"
gem "faraday-follow_redirects", "~> 0.3"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sorbet-runtime"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "better_errors"
  gem "binding_of_caller"

  gem "sorbet"
  gem "tapioca", require: false
end
