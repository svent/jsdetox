module Taka
  module DOM
    module HTML
      module ImageElement
        def name
          self['name']
        end
        
        def isMap
          !!self['ismap']
        end
      end
    end
  end
end
