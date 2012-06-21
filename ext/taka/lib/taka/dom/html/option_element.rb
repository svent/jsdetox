module Taka
  module DOM
    module HTML
      module OptionElement
        include FieldSetElement

        attr_accessor :defaultSelected

        class << self
          def extended option
            option.defaultSelected = !!option['selected']
          end
        end

        def selected
          !!self['selected']
        end

        def index
          select = parent
          while select.node_name != 'select'
            select = select.parent
          end
          select.options.each_with_index { |o,i|
            return i if o == self
          }
        end
      end
    end
  end
end
