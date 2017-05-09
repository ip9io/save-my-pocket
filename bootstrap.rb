require 'rubygems'
require 'bundler'
Bundler.require
require 'yaml'
require 'active_record'

# Define application pathes
ROOT_PATH   = File.expand_path File.dirname(__FILE__)
CONF_PATH   = File.join ROOT_PATH, 'config'
LIBS_PATH   = File.join ROOT_PATH, 'libs'
DB_PATH     = File.join ROOT_PATH, 'db'
LOG_PATH    = File.join ROOT_PATH, 'log'
MODELS_PATH = File.join ROOT_PATH, 'models'

# Define log files
DB_LOG_FILE   = File.join LOG_PATH, 'db.log'
SYNC_LOG_FILE = File.join LOG_PATH, 'sync.log'

# Load settings
require File.join CONF_PATH, 'settings'

# Database configuration
db_config = YAML::load_file File.join(CONF_PATH, 'databases.yaml')

db_config['development']['database'] =
  File.join(DB_PATH, db_config['development']['database'])

db_config['production']['database'] =
  File.join(DB_PATH, db_config['production']['database'])

ActiveRecord::Base.establish_connection db_config['development']

ActiveRecord::Base.logger = Logger.new DB_LOG_FILE

ActiveRecord::Base.logger.level = :debug

# Load models
Dir.glob(File.join MODELS_PATH, '*.rb').each { |f| require f }

# Load libraries
Dir.glob(File.join LIBS_PATH, '*.rb').each { |f| require f }


# ------------------------ TODO : tmp (will be managed later with env)
Mail.defaults do
  delivery_method :smtp, address: MAIL_HOST, port: MAIL_PORT
end
# --------------------------------------------------------------------

