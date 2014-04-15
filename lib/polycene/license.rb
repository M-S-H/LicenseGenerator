require 'rexml/document'
require_relative './context'
require_relative './restriction'
require_relative './entity_restriction'

include REXML

module Polycene
	class License
		attr_reader :doc, :context

		def initialize (id)
			@context = Context.new
			@doc = Document.new '<?xml version="1.0" encoding="utf-8"?>'
			@doc.add_element 'license', {'id' => id}
			@doc.elements[1].add_element 'permissions'
			#@doc.elements[1].elements[1].add_element 'restricted-activity', {'num' => 1, 'activity' => 'mashup'}
		end


		def add_action number, action
			@doc.elements[1].elements[1].add_element 'restricted-activity', {'num' => number, 'activity' => action}
		end


		def add_restricted_activity action, ra
			@doc.elements[1].elements[1].elements[action].add_element 'entity-restriction', {'type' => ra}
		end


		def add_restriction action, ra, property, function, value
			@doc.elements[1].elements[1].elements[action].elements[ra].add_element('restriction', {'property' => property, 'function' => function}).add_text value
		end


		def build_license (url)
			formatter = Formatters::Pretty.new(4)
			tempstring = String.new
			formatter.write(doc, tempstring)
			File.open(url, 'w+') do |f|
				f.puts tempstring
			end
		end
	end
end


