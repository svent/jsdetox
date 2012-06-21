module Taka
  module DOM
    module HTML
      module SelectElement
        include FieldSetElement

        def name
          self['name']
        end

        def options
          xpath('.//option')
        end

        def type
          return 'select-multiple' if self['multiple']
          self['type']
        end

        def selectedIndex
          options.each_with_index do |option, i|
            return i if option.selected
          end
          -1
        end

        def value
          options.each do |option|
            return option.value if option.selected
          end
          options.first.value
        end

        def length
          options.length
        end

        def size
          (self['size'] || 1).to_i
        end

        def tabIndex
          (self['tabindex'] || 0).to_i
        end

        def focus
        end

        def blur
        end

        def remove index
          (option = options[index]) && option.unlink
        end

        def add option, before = nil
          if before
            before.add_previous_sibling option
          else
            add_child option
          end
        end
      end
    end
  end
end
