module JSDetox
module JSAnalyzer
class Instance

  JS_KEYWORDS = %w(break case catch continue debugger default delete do else
                  finally for function if in instanceof new return switch
                  this throw try typeof var void while with
                  document window)

  def reformat(code)
    begin
      parser = RKelly::Parser.new
      ast = parser.parse(code)
      return ast.to_ecma
    rescue Exception
      return nil
    end
  end

  def analyze(code, new_varnames = nil, opts = {})
    begin
      count = 0
      last_result_code = nil
      new_varnames = new_varnames.delete_if { |k, v| v !~ /^[A-Za-z0-9_]+$/ } if new_varnames
      result = process_iteration(code, new_varnames, opts)
      while result[:code] != last_result_code && count < 10
        last_result_code = result[:code]
        result = process_iteration(result[:code], nil, opts)
        count += 1
      end
      result
    rescue Exception
      return nil
    end
  end

  private

  def process_iteration(code, new_varnames = nil, opts = {})
    if opts[:no_trace_vars] == "true"
      @var_store = DummyVariableStore.new
    else
      @var_store = VariableStore.new
    end
    @sens = []
    @nodes = {}
    @tree = []
    varnames = []

    parser = RKelly::Parser.new
    ast = parser.parse(code)
    process_node(ast, 0)

    @var_store.variables.each do |e|
      e[:node].skip_decl = !@var_store.has_dynamic_value?(e[:name])
    end

    varnames = []
    newcode = ast.to_ecma(varnames, new_varnames)
    varnames = varnames.uniq.sort
    varnames -= JS_KEYWORDS

    return { :code => newcode, :varnames => varnames }
  end

  def process_node(node, level, flags = {})
    flags = flags.dup
    return if !node
    return if @nodes[node]
    @nodes[node] = 1
    @tree << [node, level]
    begin

      @sens << node if node.is_a?(SourceElementsNode)

      if node.is_a?(RKelly::Nodes::ForNode) then
        node.init.parent_node = node
        node.test.parent_node = node
        node.counter.parent_node = node
        node.value.parent_node = node
        process_node(node.init, level + 2, flags.merge(:no_resolve => 1))
        process_node(node.test, level + 2, flags.merge(:no_resolve => 1))
        process_node(node.counter, level + 2, flags.merge(:no_resolve => 1))
        process_node(node.value, level + 2, flags)
      elsif node.is_a?(RKelly::Nodes::ResolveNode) && node.parent_node.is_a?(OpEqualNode) && node.parent_node.left == node then
        flags.merge!(:is_var_assign_left_node => 1)
      else
        node.map do |e|
          begin
            e.parent_node = node
            res = process_node(e, level + 2, flags)
          rescue Exception
          end
        end
      end

      if node.value.is_a?(Array)
        node.value.map! do |e|
          nv = e.newvalue rescue nil
          nv ? nv : e
        end
      end


      [ :accessor,
        :left,
        :value,
        :conditions,
        :else
      ].each do |name|
        if node.respond_to?(name)
          n = node.send(name)
          if n.respond_to?(:newvalue) && n.newvalue
            newvalue = n.newvalue
            node.instance_variable_set("@#{name.to_s}", newvalue)
          end
        end
      end

      @sens.pop if node.is_a?(SourceElementsNode)

      handlers = JSDetox::JSAnalyzer::PluginManager.get_plugins(node.class)
      if handlers
        handlers.each do |handler|
          if handler.respond_to?(:optimize)
            if node.is_a?(VarDeclNode) || node.is_a?(ResolveNode)
              if !flags[:no_resolve] && !flags[:is_var_assign_left_node]
                res = handler.optimize(node, level, @var_store, @sens.last)
              else
                if flags[:no_resolve] && node.is_a?(ResolveNode)
                  @var_store.taint!(node.value)
                end
              end
            elsif node.is_a?(ExpressionStatementNode)
              handler.optimize(node, level, @var_store, @sens.last)
            elsif node.is_a?(PrefixNode) || node.is_a?(PostfixNode)
              handler.optimize(node, level, @var_store, @sens.last)
            else
              res = handler.optimize(node, level)
            end
            return res if res
          end
        end
      end

    rescue Exception
    end
  end

end
end
end
