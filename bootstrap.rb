require 'rubygems'
require 'bundler'
Bundler.require

ROOT_PATH = File.expand_path File.dirname(__FILE__)
CONF_PATH = File.join ROOT_PATH, 'config'
LIBS_PATH = File.join ROOT_PATH, 'libs'

require File.join CONF_PATH, 'settings'

# Load libraries
Dir.glob(File.join LIBS_PATH, '*.rb').each { |f| require f }

