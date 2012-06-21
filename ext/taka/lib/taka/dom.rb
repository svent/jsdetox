require 'taka/dom/element'
require 'taka/dom/node'
require 'taka/dom/dtd'
require 'taka/dom/processing_instruction'
require 'taka/dom/document_fragment'
require 'taka/dom/document'
require 'taka/dom/comment'
require 'taka/dom/entity_decl'
require 'taka/dom/entity_reference'
require 'taka/dom/node_set'
require 'taka/dom/text'
require 'taka/dom/attr'
require 'taka/dom/named_node_map'
require 'taka/dom/attr_node_map'
require 'taka/dom/notation'
require 'taka/dom/character_data'
require 'taka/dom/node_list'
require 'taka/dom/html'

module Taka
  module DOM
    class << self
      def XML *args
        doc = Nokogiri::XML(*args)
        doc.extend(DOM::Element)
        doc.extend(DOM::Node)
        doc.extend(DOM::Document)
        doc
      end

      def HTML *args
        doc = Nokogiri::HTML(*args)
        doc.extend(DOM::Element)
        doc.extend(DOM::Node)
        doc.extend(DOM::Document)
        doc.extend(DOM::HTML::Document)
        doc.extend(Module.new {
          def decorate node
            node = super

            if node.is_a?(Nokogiri::XML::NodeSet)
              node.extend(DOM::HTML::Collection)
              return node
            end

            node.extend(DOM::HTML::Element)
            ({
              'table'     => [DOM::HTML::TableElement],
              'tr'        => [DOM::HTML::TableRowElement],
              'thead'     => [DOM::HTML::TableSectionElement],
              'tfoot'     => [DOM::HTML::TableSectionElement],
              'tbody'     => [DOM::HTML::TableSectionElement],
              'a'         => [DOM::HTML::AnchorElement],
              'applet'    => [DOM::HTML::AppletElement],
              'area'      => [DOM::HTML::AreaElement],
              'body'      => [DOM::HTML::BodyElement],
              'form'      => [DOM::HTML::FormElement],
              'button'    => [DOM::HTML::ButtonElement],
              'select'    => [DOM::HTML::SelectElement],
              'fieldset'  => [DOM::HTML::FieldSetElement],
              'frame'     => [DOM::HTML::FrameElement],
              'iframe'    => [DOM::HTML::IFrameElement],
              'img'       => [DOM::HTML::ImageElement],
              'input'     => [DOM::HTML::InputElement],
              'isindex'   => [DOM::HTML::IsIndexElement],
              'label'     => [DOM::HTML::LabelElement],
              'legend'    => [DOM::HTML::LegendElement],
              'li'        => [DOM::HTML::LiElement],
              'link'      => [DOM::HTML::LinkElement],
              'map'       => [DOM::HTML::MapElement],
              'meta'      => [DOM::HTML::MetaElement],
              'object'    => [DOM::HTML::ObjectElement],
              'ol'        => [DOM::HTML::OListElement],
              'option'    => [DOM::HTML::OptionElement],
              'param'     => [DOM::HTML::ParamElement],
              'pre'       => [DOM::HTML::PreElement],
              'script'    => [DOM::HTML::ScriptElement],
              'style'     => [DOM::HTML::StyleElement],
              'th'        => [DOM::HTML::TableCellElement],
              'td'        => [DOM::HTML::TableCellElement],
              'col'       => [DOM::HTML::ColElement],
              'colgroup'  => [DOM::HTML::ColElement],
              'textarea'  => [DOM::HTML::TextAreaElement],
              'ul'        => [DOM::HTML::UListElement],
            }[node.node_name] || []).each do |klass|
              node.extend(klass)
            end

            node
          end
        })
        doc
      end
    end
  end
end
