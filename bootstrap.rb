require 'rubygems'
require 'bundler'
Bundler.require

ROOT_PATH = File.expand_path File.dirname(__FILE__)
CONF_PATH = File.join ROOT_PATH, 'config'

require File.join CONF_PATH, 'settings'

