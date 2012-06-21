module Taka
  module DOM
    module HTML
      module LiElement
        def type
          self['type']
        end

        def value
          (self['value'] || 0).to_i
        end
      end
    end
  end
end
