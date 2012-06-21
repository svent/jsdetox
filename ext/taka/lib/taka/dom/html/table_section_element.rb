module Taka
  module DOM
    module HTML
      module TableSectionElement
        def rowIndex
          parent_table = self.parent
          while parent_table.name != 'table'
            parent_table = parent_table.parent
          end

          parent_table.rows.each_with_index do |row, i|
            return i if row == self
          end
          raise
        end

        def rows
          DOM::NodeList.new {
            xpath('./tr')
          }
        end

        def insertRow index
          tr = Nokogiri::XML::Node.new('tr', self.document)

          sibling = rows[index]

          if !sibling
            self.add_child tr
          else
            sibling.add_previous_sibling tr
          end
          tr
        end

        def deleteRow index
          (row = rows[index]) && row.unlink
        end

        def ch
          self['char']
        end

        def chOff
          self['charoff']
        end
      end
    end
  end
end
