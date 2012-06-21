taka_base = __FILE__
while File.symlink?(taka_base)
  taka_base = File.expand_path(File.readlink(taka_base), File.dirname(taka_base))
end

taka_base = File.expand_path(File.dirname(taka_base))
$: << taka_base

require 'nokogiri'
require 'taka/dom_exception'
require 'taka/dom'
require 'taka/version'

require 'taka/level2/css.rb'
require 'taka/level2/events.rb'
require 'taka/level2/views.rb'
