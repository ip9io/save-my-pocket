require './bootstrap'

set :root, ROOT_PATH
set :public_folder, 'public'
set :static, true
set :views, 'views'
set :sessions, true
set :session_secret, 'sjrfgsjgsdfgjs'

get '/' do
  haml :home
end
