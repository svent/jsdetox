module Taka
  module DOM
    module HTML
      module LabelElement
        include FieldSetElement

        def htmlFor
          self['for']
        end
      end
    end
  end
end
