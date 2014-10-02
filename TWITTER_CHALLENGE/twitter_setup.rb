require 'tweetstream'

TweetStream.configure do |config|
  config.consumer_key       = ENV["CONSUMER_KEY"]
  config.consumer_secret    = ENV["CONSUMER_SECRET"]
  config.oauth_token        = ENV["ACCESS_TOKEN"]
  config.oauth_token_secret = ENV["ACCESS_SECRET"]
  config.auth_method        = :oauth
end



