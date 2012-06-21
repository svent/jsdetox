module Taka
  module DOM
    module HTML
      module ObjectElement
        include FieldSetElement

        def code
          self['code'] || ''
        end

        def tabIndex
          (self['tabindex'] || 0).to_i
        end

        def type
          self['type']
        end

        def name
          self['name']
        end
      end
    end
  end
end
