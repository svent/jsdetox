# monkey patching
module RKelly
  module Nodes
    class Node
      attr_accessor :accessor
      attr_accessor :left
      attr_accessor :newvalue
      attr_accessor :skip_decl
      attr_accessor :conditions
      attr_accessor :else
      attr_accessor :true_block
      attr_accessor :else_block
      attr_accessor :parent_node
      attr_accessor :operand

      def to_ecma(varnames = nil, new_varnames = nil)
        ECMAVisitor.new(varnames, new_varnames).accept(self)
      end
    end

    class EmptyNode < Node
      def initialize
      end
    end
  end

  module Visitors
    class ECMAVisitor
      def initialize(varnames = nil, new_varnames = nil)
        @indent = 0
        @varnames = varnames || []
        @new_varnames = new_varnames || {}
      end

      def visit_StringNode(o)
        o.value
      end

      def visit_VarDeclNode(o)
        name = o.name
        "#{name}#{o.value ? o.value.accept(self) : nil}"
      end

      def visit_VarStatementNode(o)
        decls = o.value.map do |x|
          begin
            var_stmt = x.accept(self)
            varname = var_stmt[/^(\w+)\s*=/,1] || var_stmt
            @varnames << varname
            if @new_varnames[varname]
              var_stmt.sub!(varname, @new_varnames[varname])
              @varnames << @new_varnames[varname]
            else
              @varnames << varname
            end
            { :var_stmt => var_stmt, :skip_decl => x.skip_decl }
          rescue
            { :var_stmt => "#{x.accept(self)};", :skip_decl => false }
          end
        end
        res = ""
        res << "var " + decls.select { |e| !e[:skip_decl] }.map { |e| e[:var_stmt] }.join(", ") + ";" if decls.count { |e| !e[:skip_decl] } > 0
        res << "// var " + decls.select { |e| e[:skip_decl] }.map { |e| e[:var_stmt] }.join(", ") + ";" if decls.count { |e| e[:skip_decl] } > 0
        res
      end


      def visit_ExpressionStatementNode(o)
        if o.skip_decl
          "// #{o.value.accept(self)};"
        else
          "#{o.value.accept(self)};"
        end
      end

      def visit_ResolveNode(o)
        begin
          name = o.value
          if @new_varnames[name]
            @varnames << @new_varnames[name]
            @new_varnames[name]
          else
            @varnames << name
            name
          end
        rescue
          o.value
        end
      end

      def visit_FunctionDeclNode(o)
        begin
          name = o.value
          if @new_varnames[name]
            @varnames << @new_varnames[name]
            func_name = @new_varnames[name]
          else
            @varnames << name
            func_name = name
          end
        rescue
          func_name = name
        end
        "#{indent}function #{func_name}(" +
          "#{o.arguments.map { |x| x.accept(self) }.join(', ')})" +
          "#{o.function_body.accept(self)}"
      end

      def visit_ParameterNode(o)
        begin
          name = o.value
          if @new_varnames[name]
            @varnames << @new_varnames[name]
            @new_varnames[name]
          else
            @varnames << name
            name
          end
        rescue
          o.value
        end
      end

      def visit_EmptyNode(o)
        ""
      end

    end
  end
end
