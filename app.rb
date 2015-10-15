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
  
  tags = client.tag_search(params['tag'])
  html = "<h2>Hashtag: #{tags[0].name}</h2><h3>Used #{tags[0].media_count} times.</h3><br/><br/>"
  for media_item in client.tag_recent_media(tags[0].name)
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end
