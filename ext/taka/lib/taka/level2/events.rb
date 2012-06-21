require 'taka/level2/events/event.rb'
require 'taka/level2/events/event_exception.rb'
require 'taka/level2/events/event_listener.rb'
require 'taka/level2/events/event_target.rb'
require 'taka/level2/events/mouse_event.rb'
require 'taka/level2/events/mutation_event.rb'
require 'taka/level2/events/ui_event.rb'
require 'taka/level2/events/dom/document.rb'

Taka::DOM::Document.send(:include, Taka::EventTarget)
Taka::DOM::HTML::Element.send(:include, Taka::EventTarget)