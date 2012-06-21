#!/usr/bin/ruby

module JSDetox
module JSEngines

class Debugger
	def initialize(log)
		@log = log
	end

	def puts(*msg)
		if msg.length == 1
			@log.log JSEngines::Log::OUTPUT, "Debug Output: '%s'" % msg.first
		else
			@log.log JSEngines::Log::OUTPUT, "Debug Output: '%s'" % msg.first, { :type => 'code', :raw => msg[1] }
		end
	end

	def break(msg)
		raise "Execution stopped: '%s'" % msg
	end
end

class Log
	INFO		= 'info'
	WARNING = 'warning'
	OUTPUT	= 'output'
	ERROR		= 'error'

	attr_accessor :entries

	def log(type, msg, data = nil)
		@entries ||= []
		@entries << { :type => type, :msg => msg, :data => data }
	end
end

end
end
