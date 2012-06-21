module Taka
  module DOM
    module HTML
      module AnchorElement
        def name
          self['name']
        end

        def tabIndex
          (self['tabindex'] || 0).to_i
        end

        def type
          self['type']
        end

        def blur
          # does nothing....
        end

        def focus
          # also does nothing
        end
      end
    end
  end
end
