#!/usr/bin/ruby

require 'v8'

module JSDetox
module JSEngines
module V8Engine

class JSBase
	attr_reader :js_name

	def initialize(ctx, log, js_name)
		@ctx = ctx
		@log = log
		@js_name = js_name
		@props = {}
	end

	def [](name)
		if @props[name]
			@log.log JSEngines::Log::INFO, "accessed known property '#{name}' on '#{@js_name}', returning value '#{@props[name]}'"
			return @props[name]
		else
			@log.log JSEngines::Log::INFO, "accessed unknown property '#{name}' on '#{@js_name}'"
			return
		end
	end

	def []=(name, value)
		@log.log JSEngines::Log::INFO, "set unknown property '#{name}' on '#{@js_name}' to '#{value}'"
		@props[name] = value
	end

	def method_missing(name, *args, &block)
		@log.log JSEngines::Log::INFO, "tried to call missing method '#{name}' on '#{@js_name}', arguments: '#{args.join("|")}'"
	end

end

class JSNavigator < JSBase
end

class JSDocument < JSBase

	DOC_PROPERTIES = ["/", "URL", "all?", "anchors", "any?", "applets", "at_css",
		"at_xpath", "attribute_nodes", "attributes", "baseURI", "blank?", "body",
		"cdata?", "child", "childNodes", "children", "close", "collect",
		"collect_namespaces", "comment?", "content", "cookie",
		"createDocumentFragment", "create_element", "css", "css_path", "decorate!",
		"description", "doctype", "document", "documentElement", "documentURI",
		"domConfig", "domain", "drop_while", "each", "each_with_index", "elem?",
		"element?", "element_children", "elements", "encoding", "entries",
		"enum_with_index", "errors", "external_subset", "find_all", "firstChild",
		"first_element_child", "forms", "fragment?", "getImplementation", "group_by",
		"hasAttributes", "hasChildNodes", "html?", "images", "implementation",
		"inner_text", "inputEncoding", "internal_subset", "keys", "lastChild",
		"last_element_child", "links", "localName", "map", "max", "max_by",
		"meta_encoding", "min", "min_by", "minmax", "minmax_by", "name",
		"namespaceURI", "namespace_scopes", "namespaces", "next", "nextSibling",
		"next_element", "next_sibling", "nodeName", "nodeType", "nodeValue",
		"node_name", "node_type", "none?", "normalize", "normalizeDocument", "one?",
		"open", "ownerDocument", "parentNode", "partition", "path", "pointer_id",
		"prefix", "previous", "previousSibling", "previous_element",
		"previous_sibling", "read_only?", "referrer", "reject", "remove",
		"remove_namespaces!", "root", "search", "select", "slop!", "sort", "sort_by",
		"strictErrorChecking", "tagName", "take_while", "text", "text?", "textContent",
		"title", "to_java", "to_str", "to_xml", "traverse", "unlink", "url",
		"validate", "values", "version", "xml?", "xmlEncoding", "xmlStandalone",
		"xmlVersion", "xpath"]

	attr_reader :doc

	def initialize(ctx, log, js_name, html = nil)
		super(ctx, log, js_name)
		@doc = Taka::DOM::HTML(html)
	end

	def write(arg)
		begin
			newfrag = Nokogiri::HTML.fragment(arg)
			root = @doc.root
			root = @doc.xpath('//body').first if @doc.xpath('//body') && @doc.xpath('//body').length > 0
			root.add_child(newfrag.child)
			@log.log JSEngines::Log::WARNING, "document.write() call emulated", { :type => 'code', :raw => arg }
		rescue
			@log.log JSEngines::Log::WARNING, "failed to emulate document.write() call", { :type => 'code', :raw => arg }
		end
	end

	def [](name)
		if @doc.respond_to?(name)
			if DOC_PROPERTIES.include?(name)
				@log.log JSEngines::Log::INFO, "emulating read access on '#{@js_name}', getting property '#{name}'"
				res = @doc.send(name)
				return res
			else
				@log.log JSEngines::Log::INFO, "emulating read access on '#{@js_name}': returning function '#{name}'"
				return lambda do |*msg|
					res = @doc.send(name, *msg)
					return res
				end
			end
		else
			super(name)
		end
	end

	def []=(name, value)
		if @doc.respond_to?(name)
			@log.log JSEngines::Log::INFO, "emulating write access on #{@js_name}: '#{name}'"
			if DOC_PROPERTIES.include?(name)
				res = @doc.send("#{name}=", value)
				@log.log JSEngines::Log::INFO, "setting property '#{name}' to '#{res}'"
				return res
			end
		else
			super(name, value)
		end
	end
end

class JSWindow < JSBase
	attr_reader :document

	def initialize(ctx, log, js_name, document, navigator)
		super(ctx, log, js_name)
		@navigator = navigator
		@document = document
	end

	def navigator
		return @navigator
	end

	def unescape
		return @ctx['unescape']
	end

	def eval
		return lambda { |*msg| @log.log JSEngines::Log::WARNING, "tried to call window.eval()", { :type => 'code', :raw => msg.last } }
	end
end

class Instance

	attr_reader :log

	def execute(code, html = nil)
		ctx = V8::Context.new
		log = JSEngines::Log.new
		if !html
			html = <<-HTML
			<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
			<html><body></body></html>
			HTML
			html.strip!
		end
		document = JSDocument.new(ctx, log, "document", html)
		navigator = JSNavigator.new(ctx, log, "navigator")

		ctx['navigator'] = navigator
		ctx['document'] = document
		ctx['window'] = JSWindow.new(ctx, log, "window", document, navigator)
		ctx['jsdetox'] = Debugger.new(log)
		ctx['eval'] = lambda { |*code| log.log JSEngines::Log::WARNING, "tried to call eval()" % code, { :type => 'code', :raw => code.last } }

		begin
			ctx.eval(code)
		rescue => e
			msg = e.message.to_s
			line = e.backtrace.to_s[/at\s<eval>:(\d+):\d+/, 1]
			msg << " (Line #{line})" if line
			log.log(JSEngines::Log::ERROR, msg, { :type => 'trace', :raw => e.backtrace })
		end
		{
			:log => log.entries,
			:html => document.doc.to_html
		}
	end
end

end
end
end

