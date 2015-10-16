require "sinatra"
require "instagram"
require "twitter"
require 'dotenv'
Dotenv.load

Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID']
end

twitterClient = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
end

enable :sessions

get "/" do
  erb :index
end 

get "/:tag" do
  theTag = params['tag']
  
  instagramClient = Instagram.client(:access_token => session[:access_token])
  
  html = "<form action=''>
  <input type='text' placeholder='search hashtag'>
  <button type='submit' id='js-search-hashtag'>Search</button>
  </form>"

  tags = instagramClient.tag_search(theTag)
  
  html = "<h2>Hashtag: #{tags[0].name}</h2><h3>Used #{tags[0].media_count} times.</h3><br/><br/>"
  
  for media_item in instagramClient.tag_recent_media(tags[0].name)
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end

  twitterSearch = twitterClient.search("#" + theTag + " -rt", result_type: "mixed").take(20)

  for tweet in twitterSearch
    html << "<li>#{ tweet.text }</li>"
  end

  html
end