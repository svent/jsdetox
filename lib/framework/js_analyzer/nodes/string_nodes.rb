#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class StringNodes < Plugin
	handle StringNode

	PRINTABLE = (0x20..0x7e).to_a - [0x22, 0x27, 0x5c]

	def self.optimize(node, level)
		if node.is_a?(RKelly::Nodes::StringNode)
			str = node.value
			if str[0, 1] == '"' && str[-1, 1] == '"'
				quote = '"'
			elsif str[0, 1] == "'" && str[-1, 1] == "'"
				quote = "'"
			else
				return str
			end
			str = str[1..-2]
			buf = ""
			while str.length > 0
				if str[0, 1] == "\\"
					str.slice!(0, 1)
					case str[0, 1]
					when '"', "'", "\\", " ", "n", "r", "t"
						buf << "\\" + str.slice!(0,1)
					when "x", /[0-7]/
						if str[0, 1] == "x"
							str.slice!(0, 1)
							ord = str.slice!(0,2).to_i 16
						else
							op = str[/([0-7]{1,3})/]
							ord = op.to_i(8)
							if ord > 255
								op = str[/([0-7]{1,2})/]
								ord = op.to_i(8)
							end
							str.slice!(0, op.length)
						end
						if PRINTABLE.include?(ord)
							buf << ord.chr
						else
							buf << "\\x" + ord.to_s(16)
						end 
					when "u"
						str.slice!(0, 1)
						ord = str.slice!(0,4).to_i 16
						if PRINTABLE.include?(ord)
							buf << ord.chr
						else
							buf << "\\x" + ord.to_s(16)
						end 
					end   
				else
					buf << str.slice!(0, 1)
				end
			end
			buf = quote + buf + quote
			res = RKelly::Nodes::StringNode.new(buf)
			node.newvalue = res
			return res
		end
	end
end

end
end
end
