module Taka
  module DOM
    module HTML
      module InputElement
        include FieldSetElement

        attr_accessor :defaultValue, :defaultChecked

        class << self
          def extended input
            input.defaultValue ||= input['value']
            input.defaultChecked = !!input['checked']
          end
        end

        def checked
          !!self['checked']
        end

        def maxLength
          self['maxlength'].to_i
        end

        def name
          self['name']
        end

        def tabIndex
          self['tabindex'].to_i
        end

        def type
          self['type']
        end

        def accept
          self['accept']
        end

        def blur
        end

        def focus
        end

        def select
        end

        def click
          self['checked'] = checked ? nil : 'checked'
        end
      end
    end
  end
end
