module Taka
  module DOM
    module HTML
      module TableRowElement
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

        def cells
          xpath('.//td', './/th')
        end

        def sectionRowIndex
          parent.xpath('./tr').each_with_index do |tr, i|
            return i if tr == self
          end
        end

        def insertCell index
          td = Nokogiri::XML::Node.new('td', self.document)
          cell = cells[index]
          if cell
            cell.add_previous_sibling td
          else
            add_child td
          end
        end

        def deleteCell index
          (cell = cells[index]) && cell.unlink
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
