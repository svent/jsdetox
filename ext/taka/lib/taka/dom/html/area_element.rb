module Taka
  module DOM
    module HTML
      module AreaElement
        def noHref
          !self['href']
        end

        def tabIndex
          (self['tabindex'] || 0).to_i
        end
      end
    end
  end
end
