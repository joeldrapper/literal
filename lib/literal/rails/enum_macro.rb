# frozen_string_literal: true

module Literal::Rails::EnumMacro
	def literal_enum(attribute_name, enum, **)
		attribute(attribute_name, :literal_enum, type: enum, subtype: type_for_attribute(attribute_name), **)
	end
end
