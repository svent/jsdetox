#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class FunctionCalls < Plugin
	handle FunctionCallNode
	handle DotAccessorNode

	def self.optimize(node, level)
		if node.is_a?(RKelly::Nodes::FunctionCallNode)
			da = node.value
			return if !da.is_a?(DotAccessorNode)

			if da.value.is_a?(NumberNode) && da.accessor.to_s == "toString" && node.arguments.value.length == 1 && node.arguments.value[0].is_a?(NumberNode)
				base = da.value.value.to_s
				arg1 = node.arguments.value[0].value.to_i
				node.newvalue = StringNode.new( '"' + da.value.value.to_i.to_s(arg1) + '"' )
			end

			if da.value.is_a?(ResolveNode) && da.value.value.to_s == "String" && da.accessor.to_s == "fromCharCode"

				return if node.arguments.value.find { |e| !e.is_a?(NumberNode) }
				node.newvalue = StringNode.new('"' + node.arguments.value.map{ |e| e.value.chr}.join('') + '"')
			end

			if da.value.is_a?(StringNode) && da.accessor.to_s == "indexOf" && node.arguments.value.length == 1 && node.arguments.value[0].is_a?(StringNode)
				base = da.value.value.to_s.gsub(/^['"]?|['"]?$/, "")
				arg1 = node.arguments.value[0].value.to_s.gsub(/^['"]?|['"]?$/, "")
				node.newvalue = NumberNode.new(base.index(arg1) || -1)
			end

			if da.value.is_a?(StringNode) && da.accessor.to_s == "length"
				base = da.value.value.to_s.gsub(/^['"]?|['"]?$/, "")
				node.newvalue = NumberNode.new(base.length)
			end
		end

		if node.is_a?(RKelly::Nodes::DotAccessorNode)
			if node.value.is_a?(StringNode) && node.accessor.to_s == "length"
				base = node.value.value.to_s.gsub(/^['"]?|['"]?$/, "")
				node.newvalue = NumberNode.new(base.length)
			end
		end
	end
end

class AnonymousFunctionCalls < Plugin
	handle FunctionCallNode

	def self.optimize(node, level)
		if node.is_a?(RKelly::Nodes::FunctionCallNode)
			fc = node
			if node.value.is_a?(ParentheticalNode)
				fe = fc.value.value
			else
				fe = fc.value
			end
			if fe.is_a?(FunctionExprNode)
				if (fb = fe.function_body) && fb.is_a?(FunctionBodyNode)
					if (se = fb.value) && se.is_a?(SourceElementsNode) && se.value.is_a?(Array)
						valid_subnodes = se.value.select { |e| e.newvalue != "" }
						valid_subnodes = se.value
						if valid_subnodes.length == 1 && (r = valid_subnodes[0]) && r.is_a?(ReturnNode)
							if r.value.is_a?(StringNode) || r.value.is_a?(NumberNode)
								node.newvalue = r.value
								return r.value
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
