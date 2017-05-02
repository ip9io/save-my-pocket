# -----------------------------------------------------
# Save My Pocket
# @author : ip9io
# -----------------------------------------------------
require './bootstrap'


# -----------------------------------------------------
# Configure Pocket Library
# -----------------------------------------------------
CALLBACK_URL = APP_URL + '/pocket/oauth/callback'

Pocket.configure do |config|
  config.consumer_key = POCKET_CONSUMER_KEY
end


# -----------------------------------------------------
# App Settings
# -----------------------------------------------------
set :root, ROOT_PATH
set :public_folder, 'public'
set :static, true
set :views, 'views'
set :sessions, true
set :session_secret, SESSION_SECRET


# -----------------------------------------------------
# Local App
# -----------------------------------------------------
get '/' do
  @bookmarks = Bookmark::all.order time_added: :desc
  haml :home
end

get '/bookmark/json/:id' do
  content_type 'application/json; charset=UTF-8'
  item = Bookmark::find params[:id]
  item.json
end

get '/logout' do
  session.clear
  redirect '/'
end


# -----------------------------------------------------
#  Pocket Api Interaction
# -----------------------------------------------------
get '/pocket/oauth/connect' do
  session[:code] = Pocket.get_code redirect_uri: CALLBACK_URL
  redirect Pocket.authorize_url code: session[:code], redirect_uri: CALLBACK_URL
end

get '/pocket/oauth/callback' do
  result = Pocket.get_result session[:code], redirect_uri: CALLBACK_URL
  session[:access_token] = result['access_token']
  redirect '/'
end

get '/pocket/all/:offset/:nb' do
  content_type 'application/json; charset=UTF-8'
  client = Pocket.client access_token: session[:access_token]
  info = client.retrieve detailType: :complete, sort: :newest, offset: params[:offset], count: params[:nb]
  info.to_json
end

