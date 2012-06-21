#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class VariableNodes < Plugin
	handle VarDeclNode
	handle ResolveNode
	handle ExpressionStatementNode

	def self.optimize(node, level, var_store, sen)
		if node.is_a?(VarDeclNode)
			name = node.name
			if node.value == nil
				var_store.set_var(level, name, NullNode.new(nil), sen, node)
				return
			end
			ae = node.value
			if ae.is_a?(AssignExprNode)
				if ae.value.is_a?(StringNode) || ae.value.is_a?(NumberNode)
					var_store.set_var(level, name, ae.value, sen, node)
				else
					if v = var_store.get_var(level, name, sen)
						v[:tainted] = true
					end
				end
			end
		end

		if node.is_a?(ResolveNode)
			name = node.value
			value = var_store.resolve(level, name, sen)
			if value
				node.newvalue = value
				return value
			end
		end

		if node.is_a?(ExpressionStatementNode)
			if node.value.is_a?(OpEqualNode)
				oe = node.value
				name = oe.left.value.to_s
			end
			if node.value.class == OpEqualNode
				return if !oe.left.is_a?(ResolveNode)
				if oe.value.is_a?(StringNode) || oe.value.is_a?(NumberNode)
					var_store.set_var(level, name, oe.value, sen, node)
				else
					var_store.taint!(name)
				end
			elsif node.value.is_a?(OpEqualNode)
				var_store.taint!(name)
			end
		end
	end
end

end
end
end
