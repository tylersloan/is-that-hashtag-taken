require "sinatra"
require "instagram"

enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

Instagram.configure do |config|
  config.client_id = "270d07af06de479aa7e8798b5cf761f9"
end

get "/" do
  erb :index
end

get "/tags/:tag" do
  client = Instagram.client(:access_token => session[:access_token])
  # html = "<h1>Search for tags, get tag info and get media by tag</h1><input id='search' type='text' />"
  tags = client.tag_search(params['tag'])
  html = "<h2>Tag Name = #{tags[0].name}. Media Count =  #{tags[0].media_count}. </h2><br/><br/>"
  for media_item in client.tag_recent_media(tags[0].name)
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end
