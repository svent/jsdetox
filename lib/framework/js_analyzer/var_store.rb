module JSDetox
module JSAnalyzer
class VariableStore
  attr_reader :variables

  def initialize
    @variables = []
    @tainted_vars = {}
  end

  def resolve(level, name, sen)
    value = nil
    begin
      item = @variables.select { |e| e[:name] == name && e[:sen] == sen }.last
      if !item
        taint!(name)
        return
      end
      return if item[:tainted]
      return item[:value]
    rescue
      return
    end
  end

  def get_var(level, name, sen)
    begin
      item = @variables.select { |e| e[:name] == name && e[:sen] == sen }.last
      return item
    rescue
      return
    end
  end

  def taint!(name)
    @tainted_vars[name] = true
    if vars = get_vars_by_name(name)
      vars.each do |e|
        e[:tainted] = true
      end
    end
  end

  def get_vars_by_name(name)
    begin
      items = @variables.select { |e| e[:name] == name }
      return items
    rescue
      return
    end
  end

  def has_dynamic_value?(name)
    begin
      items = @variables.select { |e| e[:name] == name }
      return true if items.length == 0
      return items.select { |e| e[:tainted] }.length > 0
    rescue
      return true
    end
  end

  def set_var(level, name, value, sen, node)
    vars = get_vars_by_name(name)
    if vars
      if vars.select{ |e| e[:sen] != sen }.length > 0
        taint!(name)
      end
    end
    @variables << {:name => name, :value => value, :level => level, :sen => sen, :node => node, :tainted => @tainted_vars[name] }
  end

end

class DummyVariableStore < VariableStore
  def resolve(level, name, sen)
    return nil
  end

  def get_var(level, name, sen)
    return nil
  end

  def has_dynamic_value?(name)
    return true
  end
end

end
end
