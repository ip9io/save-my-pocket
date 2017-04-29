require './bootstrap'

CALLBACK_URL = APP_URL + '...'

Pocket.configure do |config|
  config.consumer_key = POCKET_CONSUMER_KEY
end


set :root, ROOT_PATH
set :public_folder, 'public'
set :static, true
set :views, 'views'
set :sessions, true
set :session_secret, SESSION_SECRET

get '/' do
  haml :home
end

get '/logout' do
  session.clear
  redirect '/'
end

