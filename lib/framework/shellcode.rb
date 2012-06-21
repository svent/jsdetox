#!/usr/bin/env ruby

module JSDetox
module Analysis

class XorAnalyzer
	PATTERNS = [ /http:\/\//, /ftp:\/\//, /\.dll/, /\.exe/ ]

	def self.analyze(data)
		matches = []
		0.upto(255) do |key|
			decoded = data.unpack("C*").map { |e| e ^ key }.pack("C*")
			matching_patterns = []
			PATTERNS.each do |p|
				matching_patterns << p.source if decoded.match(p)
			end
			if !matching_patterns.empty?
				matches << {:key => key, :patterns => matching_patterns, :data => decoded }
			end 
		end
		matches
	end
end

end
end
