module Taka
  module DOM
    module HTML
      module TableCellElement
        def cellIndex
          tr = parent
          while tr.node_name != 'tr'
            tr = tr.parent
          end
          tr.cells.each_with_index do |cell,i|
            return i if cell == self
          end
        end

        def ch
          self['char']
        end

        def chOff
          self['charoff']
        end

        def colSpan
          self['colspan'] && self['colspan'].to_i
        end

        def rowSpan
          self['rowspan'] && self['rowspan'].to_i
        end
      end
    end
  end
end
