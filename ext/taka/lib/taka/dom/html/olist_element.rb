module Taka
  module DOM
    module HTML
      module OListElement
        def start
          (self['start'] || 0).to_i
        end

        def type
          self['type']
        end
      end
    end
  end
end
