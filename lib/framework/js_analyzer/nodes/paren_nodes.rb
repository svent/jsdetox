#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class ParenNodes < Plugin
	handle ParentheticalNode

	def self.optimize(node, level)
		if node.is_a?(ParentheticalNode)
			val = node.value
			if val.is_a?(StringNode) || val.is_a?(NumberNode)
				node.newvalue = val
				return val
			end
		end

		if node.is_a?(ParentheticalNode)
			cn = node.value
			if cn.is_a?(CommaNode)
				oe = cn.left
				fc = cn.value
				if oe.is_a?(OpEqualNode) && fc.is_a?(FunctionCallNode)
					res1 = oe.left
					da = oe.value
					res2 = fc.value
					if res1.is_a?(ResolveNode) && da.is_a?(DotAccessorNode) && res2.is_a?(ResolveNode)
						ol = da.value
						if ol.is_a?(ObjectLiteralNode)
							if res1 == res2 && da.accessor = "valueOf"
								node.newvalue = ResolveNode.new("window")
							end
						end
					end
				end
			end
		end
	end
end

end
end
end
