source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "dm_unibo_user_search", git: "https://github.com/donapieppo/dm_unibo_user_search.git"
gem "dm_unibo_common", git: "https://github.com/donapieppo/dm_unibo_common.git", branch: "master"
# gem "dm_unibo_common", path: "/home/rails/gems/dm_unibo_common/"

gem "jsbundling-rails"
gem "cssbundling-rails", "~> 1.1"

gem "rqrcode"

gem "prawn"
gem "prawn-table"
gem "prawn-svg"

# gem 'aasm'

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  # gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "ruby-lsp", require: false
end

group :development do
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem "spring"
end

group :test do
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end
