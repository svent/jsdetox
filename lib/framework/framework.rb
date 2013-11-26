#!/usr/bin/ruby

frameworkbase = __FILE__
while File.symlink?(frameworkbase)
  frameworkbase = File.expand_path(File.readlink(frameworkbase), File.dirname(frameworkbase))
end

frameworkbase = File.expand_path(File.dirname(frameworkbase))
$: << frameworkbase

include RKelly::Nodes

require 'monkey_patches'
require 'js_analyzer/plugin_manager'
require 'js_analyzer/plugin'
require 'js_analyzer/var_store'
require 'js_analyzer/instance'
require 'jsengine_v8'

Dir.glob(File.join(frameworkbase, "js_analyzer/nodes/*.rb")).each do |file|
  require file
end

module JSDetox
  VERSION = "0.1.4"
end
