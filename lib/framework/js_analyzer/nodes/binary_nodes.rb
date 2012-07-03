#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

BinaryNodes = {
	AddNode => '+',
	SubtractNode => '-',
	MultiplyNode => '*',
	DivideNode => '/',
	LessNode => '<',
	LessOrEqualNode => '<=',
	GreaterNode => '>',
	GreaterOrEqualNode => '>=',
	EqualNode => '==',
	NotEqualNode => 'undefined',
}

class MiscBinaryNodes < Plugin
	BinaryNodes.keys.each do |e|
		handle e
	end

	def self.optimize(node, level)
		if BinaryNodes.include?(node.class) && node.left.is_a?(RKelly::Nodes::NumberNode) && node.value.is_a?(RKelly::Nodes::NumberNode)
			if node.is_a?(NotEqualNode)
				res = node.left.value != node.value.value
			elsif node.class == DivideNode
				if node.left.value.class == Fixnum && node.value.value.class == Fixnum && node.left.value % node.value.value == 0
					res = node.left.value / node.value.value
				else
					return
				end
			else
				res = node.left.value.send(BinaryNodes[node.class].to_sym, node.value.value)
			end
			if res == true
				new_node = RKelly::Nodes::TrueNode.new(true)
			elsif res == false
				new_node = RKelly::Nodes::FalseNode.new(false)
			else
				new_node = RKelly::Nodes::NumberNode.new(res)
			end
			node.newvalue = new_node
			return new_node
		end

	end
end

class AddNodeStrings < Plugin
	handle RKelly::Nodes::AddNode

	def self.optimize(node, level)
		if node.is_a?(RKelly::Nodes::AddNode) && node.left.is_a?(RKelly::Nodes::StringNode) && node.value.is_a?(RKelly::Nodes::StringNode)
			left = node.left.value.to_s[1..-2]
			right = node.value.value.to_s[1..-2]
			quote_left = node.left.value.to_s[0, 1]
			quote_right = node.value.value.to_s[0, 1]
			left.gsub!(/.?"/) { |e| (e == '"' || e == '\\"') ? '\\"' : e[0, 1] + '\\"' } if quote_left == "'"
			right.gsub!(/.?"/) { |e| (e == '"' || e == '\\"') ? '\\"' : e[0, 1] + '\\"' } if quote_right == "'"
			concat = '"' + left + right + '"'
			res = RKelly::Nodes::StringNode.new(concat)
			node.newvalue = res
			return res
		end
	end
end

end
end
end
