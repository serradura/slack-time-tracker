source "https://rubygems.org"

ruby "2.3.0"

gem "rails", "4.2.5"
gem "rails-api", "~> 0.4.0"

group :production do
  gem "pg", "~> 0.18.4"
  gem "puma", "~> 2.15", ">= 2.15.3"
end

group :development, :test do
  # Development
  # gem "spring", "~> 1.6", ">= 1.6.2"
  gem "sqlite3", "~> 1.3", ">= 1.3.11"
  gem "dotenv-rails", "~> 2.1"
  gem "awesome_print", "~> 1.6", ">= 1.6.1"

  # Code Quality
  gem "simplecov", "~> 0.11.1", require: false
  gem "rubycritic", "~> 2.4", ">= 2.4.1", require: false
  gem "rubocop", "~> 0.35.1", require: false
  gem "brakeman", "~> 3.1", ">= 3.1.4", require: false

  gem "guard", "~> 2.13"
  gem "guard-rspec", "~> 4.6", ">= 4.6.4", require: false
  gem "guard-rubocop", "~> 1.2", require: false
  gem "guard-brakeman", "~> 0.8.3", require: false

  # Debugging
  gem "pry-rails", "~> 0.3.4"
  gem "pry-doc", "~> 0.8.0"
  gem "pry-byebug", "~> 3.3"

  # Test
  gem "factory_girl_rails", "~> 4.5"
  gem "faker", "~> 1.6", ">= 1.6.1"
end

group :test do
  gem "rspec-rails", "~> 3.4"
  gem "database_cleaner", "~> 1.5", ">= 1.5.1"
end

# To use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# To use Jbuilder templates for JSON
# gem "jbuilder"
