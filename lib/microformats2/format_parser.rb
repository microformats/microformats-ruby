module Microformats2
  class FormatParser
		class << self
			def parse(element)
				parse_node(element)
			end

			def parse_node(node)
				case
				when node.is_a?(Nokogiri::XML::NodeSet) then parse_nodeset(node)
				when node.is_a?(Nokogiri::XML::Element) then parse_for_microformats(node)
				end
			end

			def parse_nodeset(nodeset)
				nodeset.map { |node| parse_node(node) }
			end

			def parse_for_microformats(element)
				if format_classes(element).length >= 1
					parse_microformat(element)
				else
					parse_nodeset(element.children)
				end
			end

			def parse_microformat(element)
				# only worry about the first format for now
				html_class = format_classes(element).first
				# class-name -> class_name
				method_name = html_class.downcase.gsub("-","_")
				# class_name -> Class_name -> ClassName
				constant_name = method_name.gsub(/^([a-z])/){$1.upcase}.gsub(/_(.)/){$1.upcase}

				# find or create ruby class for microformat
				if Object.const_defined?(constant_name)
					klass = Object.const_get(constant_name)
				else
					klass = Class.new(Microformats2::Format)
					Object.const_set constant_name, klass
				end

				# parse microformat
				klass.new(element).parse
			end

			def format_classes(element)
				element.attribute("class").to_s.split.select do |html_class|
					html_class =~ Format::CLASS_REG_EXP
				end
			end
		end
  end
end
