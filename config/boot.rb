# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)


Padrino.before_load do
  require File.join(PADRINO_ROOT, 'ext/metasm/metasm')
  require File.join(PADRINO_ROOT, 'ext/taka/lib/taka')
  $: << File.join(PADRINO_ROOT, 'ext/rkelly/lib')
  require File.join(PADRINO_ROOT, 'ext/rkelly/lib/rkelly')
end

Padrino.after_load do
end

Padrino.load!
