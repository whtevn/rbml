$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/../languages") 
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) 
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))+"/local") 

if ENV['RBML'] and not @gem_only 
	$LOAD_PATH.unshift(ENV['RBML'])
	$LOAD_PATH.unshift(ENV['RBML']+"/lib")
	$LOAD_PATH.unshift(ENV['RBML']+"/languages")
	ENV['routes'] ||= ENV['RBML']+"/config/language.map"
else
	ENV['routes'] ||= File.expand_path(File.dirname(__FILE__))+"/../config/languages.map" 
	puts 'using only gem libraries'
end


module Rbml
  VERSION = '0.0.6'
end

require 'yaml'
require 'extensions/primitives'
require 'extensions/string'
require 'processor'
require 'base'
require 'doc'
require 'shell'
require 'script'
require 'processor'
require 'procedural'
