module Taka
  module DOM
    module HTML
      module MapElement
        def areas
          xpath('.//area')
        end

        def name
          self['name']
        end
      end
    end
  end
end
