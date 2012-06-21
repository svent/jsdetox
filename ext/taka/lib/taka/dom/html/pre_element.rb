module Taka
  module DOM
    module HTML
      module PreElement
        def width
          self['width'] && self['width'].to_i
        end
      end
    end
  end
end
