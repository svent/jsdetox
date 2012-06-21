module Taka
  module DOM
    module HTML
      module FormElement
        def elements
          xpath('.//select', './/textarea', './/input')
        end

        def length
          elements.length
        end

        def acceptCharset
          self['accept-charset']
        end

        def method
          self['method']
        end

        def reset
          elements.each do |element|
            next unless element.respond_to?(:defaultValue)
            element['value'] = element.defaultValue
          end
        end

        def submit
          # Does nothing for now
        end
      end
    end
  end
end
