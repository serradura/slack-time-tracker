# Slack Time Tracker Command
This project is based on post: [Building a Slack slash command with Sinatra, Finch and Heroku](https://wearestac.com/blog/building-a-slack-slash-command-with-sinatra-finch-and-heroku)

## Ruby version
2.3.0

## Development Setup
```sh
# Install ruby 2.3.0, e.g:
# rvm install 2.3.0
# rvm use 2.3.0
# cp sample.ruby-version .ruby-version

# Install all development dependencies
bundle install -j 6

# Generate a .env
cp sample.env .env

# Change all environment variables, e.g:
# atom .env

# Create and configure the database
bundle exec rake db:create
bundle exec rake db:migrate

# Run the test suite
bundle exec rspec

# Start the server
bundle exec rails s webrick

# In another terminal tab/window.
# Start guard
bundle exec guard

# After change something or create a new behaviour/feature, execute:
bundle exec rubycritic app lib
# and open the code quality report
# open tmp/rubycritic/overview.html
```

## Deployment
```sh
  # Heroku
  # If was the first deployment
  # You need to create the database
  # heroku run console rake db:create
  # heroku run console rake db:migrate

  git push heroku master
  # If there is changes on database, run:
  # heroku run console rake db:migrate

  # Environment Variables:
  heroku config:set SLACK_TOKEN=YOUR_SLACK_TOKEN
```

## Contributing
* Git: This project follow [git-flow](http://nvie.com/posts/a-successful-git-branching-model/).

## TODO

* Services (job queues, cache servers, search engines, etc.)
