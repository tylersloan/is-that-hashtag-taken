require "sinatra"
require "instagram"
require "twitter"

load 'instagram_config.rb'
load 'twitter_config.rb'

enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

get "/" do
  erb :index
end 

get "/:tag" do
  client = Instagram.client(:access_token => session[:access_token])
  html = "<form action=''>
  <input type='text' placeholder='search hashtag'>
  <button type='submit' id='js-search-hashtag'>Search</button>
  </form>"
  tags = client.tag_search(params['tag'])
  html = "<h2>Hashtag: #{tags[0].name}</h2><h3>Used #{tags[0].media_count} times.</h3><br/><br/>"
  for media_item in client.tag_recent_media(tags[0].name)
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end