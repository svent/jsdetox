module Taka
  module DOM
    module HTML
      module ColElement
        def ch
          self['char']
        end

        def chOff
          self['charoff']
        end

        def span
          self.key?('span') && self['span'].to_i
        end
      end
    end
  end
end
