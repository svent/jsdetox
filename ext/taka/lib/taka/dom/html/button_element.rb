module Taka
  module DOM
    module HTML
      module ButtonElement
        include FieldSetElement

        def name
          self['name']
        end

        def tabIndex
          (self['tabindex'] || 0).to_i
        end

        def type
          self['type']
        end
      end
    end
  end
end
