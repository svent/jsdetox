#!/usr/bin/ruby

require 'v8'
require 'base64'

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

  DOCUMENT_PROPERTIES =	%w(
                          anchors applets body cookie documentMode domain forms
                          images lastModified links readyState referrer title URL attributes baseURI
                          childNodes firstChild lastChild localName namespaceURI nextSibling nodeName
                          nodeType nodeValue ownerDocument parentNode prefix previousSibling textContent
                        )

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
      if DOCUMENT_PROPERTIES.include?(name)
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
      if DOCUMENT_PROPERTIES.include?(name)
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

  WINDOW_PROPERTIES 	=	%w(
                          closed defaultStatus document frames history
                          innerHeight innerWidth length location name navigator opener outerHeight
                          outerWidth pageXOffset pageYOffset parent screen screenLeft screenTop screenX
                          screenY self status top
                        )

  WINDOW_FUNCTIONS		=	%w(
                          alert blur clearInterval clearTimeout close confirm createPopup focus moveBy
                          moveTo open print prompt resizeBy resizeTo scroll scrollBy scrollTo setInterval
                          setTimeout
                        )

  attr_reader :document

  def initialize(ctx, log, js_name, document, navigator)
    super(ctx, log, js_name)
    @navigator = navigator
    @document = document
  end

  def atob(data)
    @ctx['atob'].call(data)
  end

  def btoa(data)
    @ctx['btoa'].call(data)
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

  def [](name)
    if ![WINDOW_PROPERTIES + WINDOW_FUNCTIONS].include?(name)
      res = @ctx[name]
      if res
        @log.log JSEngines::Log::INFO, "emulating read access on '#{@js_name}', unknown property/method '#{name}'"
        @log.log JSEngines::Log::INFO, "global function '#{name}' exists, emulating call of global function '#{name}' through '#{@js_name}.#{name}()'"
        return res
      else
        super(name)
      end
    else
      super(name)
    end
  end
end

class Instance

  attr_reader :log

  def execute(code, opts = {}, html = nil)
    @eval_count = 0
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
    ctx['atob'] = lambda do |*data|
      return Base64.decode64(data.map(&:to_s).join(''))
    end
    ctx['btoa'] = lambda do |*data|
      return Base64.encode64(data.map(&:to_s).join('')).gsub("\n", '')
    end
    if opts[:exec_eval] == "true"
      ctx['eval'] = lambda do |*code|
        @eval_count += 1
        if @eval_count > 1000
          raise "Aborting, traced more than 1000 eval() calls."
        end
        log.log JSEngines::Log::WARNING, "eval() call executed" % code, { :type => 'code', :raw => code.last }

        if code.last.is_a?(Proc) || code.last.is_a?(V8::Function)
          return code.last
        end
        return ctx.eval(code.last)
      end
    else
      ctx['eval'] = lambda do |*code|
        @eval_count += 1
        if @eval_count > 1000
          raise "Aborting, traced more than 1000 eval() calls. The code might contain eval() calls designed to hinder analysis, the option 'Execute eval() statements' might help in these cases."
        end
        log.log JSEngines::Log::WARNING, "tried to call eval()" % code, { :type => 'code', :raw => code.last }
      end
    end

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

