JSDetoxWeb.controllers :backend do

  post :analyze, :provides => :json do
    if params[:code]
      orig_code = params[:code]
      new_varnames = params[:new_varnames]
      opts = params[:opts] || {}
      session[:orig_code] = orig_code
      framework = JSDetox::JSAnalyzer::Instance.new
      result = framework.analyze(orig_code, new_varnames, opts)
      if result
        return {
          :status => :ok,
          :code => result[:code],
          :varnames => result[:varnames],
        }.to_json
      else
        return { :status => :error }.to_json
      end
    end
  end

  post :reformat, :provides => :json do
    if params[:code]
      orig_code = params[:code]
      session[:orig_code] = orig_code
      framework = JSDetox::JSAnalyzer::Instance.new
      result = framework.reformat(orig_code)
      if result
        {
          :status => :ok,
          :code => result,
        }.to_json
      else
        return { :status => :error }.to_json
      end
    end
  end

  post :execute, :provides => :json do
    if params[:code]
      session[:orig_code] = params[:code]
      htmldoc = session[:htmldoc]
      opts = params[:opts] || {}

      engine = JSDetox::JSEngines::V8Engine::Instance.new
      res = engine.execute(params[:code], opts, htmldoc)
      res.to_json
    end
  end

  post :upload, :provides => :json do
    if htmldoc = params[:html_file]
      data = htmldoc[:tempfile].read
      session[:htmldoc] = data
    elsif jsdoc = params[:js_file]
      data = jsdoc[:tempfile].read
      session[:orig_code] = data
    elsif datadoc = params[:data_file]
      data = datadoc[:tempfile].read
      session[:data_raw] = data
    else
      return { :status => 'error' }.to_json
    end
    data.force_encoding('UTF-8') if data.respond_to?(:force_encoding)
    {
      :status => 'ok',
      :raw => data,
    }.to_json
  end

  post :store_html, :provides => :json do
    if params[:html]
      session[:htmldoc] = params[:html]
      return { :status => 'ok' }.to_json
    end
  end

  post :data_analyze, :provides => :json do
    dump = ""
    action = params[:action]
    opts = params[:opts]
    if action && params[:data]
      case action
      when 'raw'
        data = params[:data]
      when 'hex'
        data = params[:data]
        data = data.scan(/[A-Fa-f0-9]{2}/).map(&:hex).pack("C*")
      when 'unicode'
        data = params[:data]
        data = data.scan(/%u([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})/).map(&:reverse).flatten.map(&:hex).pack("C*")
      else
        return
      end
      session[:data_raw] = params[:data]
      Hexdump.dump(data, :word_size => 1, :output => dump)
      begin
        disasm = JSDetox::Disassembler.disassemble(data, opts)
      rescue
        disasm = nil
      end
      begin
        analysis_xor = JSDetox::Analysis::XorAnalyzer.analyze(data)
        analysis_xor.map! do |e|
          buffer = ""
          Hexdump.dump(e[:data], :word_size => 1, :output => buffer)
          e[:data] = buffer
          e[:patterns] = e[:patterns].join(', ')
          e[:key] = "%d (0x%s)" % [ e[:key], e[:key].to_s(16) ]
          e
        end
      rescue
        analysis_xor = nil
      end
    end
    {
      :status => :ok,
      :dump => dump,
      :disasm => disasm,
      :analysis_xor => analysis_xor,
    }.to_json
  end

  post :extract_script_tags, :provides => :json do
    begin
      html = session[:htmldoc]
      if html
        doc = Taka::DOM::HTML(html)
        script_tags = doc.getElementsByTagName('script').map(&:innerHTML)
        {
          :status => :ok,
          :tag_count => script_tags.length,
          :tags => script_tags,
        }.to_json
      else
        {
          :status => :ok,
          :tag_count => 0,
        }.to_json
      end
    rescue
      return { :status => :error }.to_json
    end
  end

end
