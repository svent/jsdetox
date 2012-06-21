module Taka
  module DOM
    module HTML
      module FieldSetElement
        def form
          my_parent = parent
          while my_parent.respond_to?(:parent)
            return my_parent if my_parent.node_name == 'form'
            my_parent = my_parent.parent
          end
        end
      end
    end
  end
end
