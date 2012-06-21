#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class IfNodes < Plugin
	handle IfNode
	handle ConditionalNode

	def self.optimize(node, level)
		if node.is_a?(IfNode)
			cond = nil
			cond = true if node.conditions.is_a?(NumberNode) && node.conditions.value != 0
			cond = true if node.conditions.is_a?(TrueNode)
			cond = false if node.conditions.is_a?(NumberNode) && node.conditions.value == 0
			cond = false if node.conditions.is_a?(FalseNode)
			if cond != nil
				if cond
					node.newvalue = node.value
				else
					if node.else
						node.newvalue = node.else
					else
						node.newvalue = EmptyNode.new
					end
				end
			end
		end
	end
end

end
end
end
