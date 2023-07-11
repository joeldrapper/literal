# frozen_string_literal: true

module Literal::Attributes::Generators
	class IVarInitializer < Initializer
		private

		def assign_values
			Section.new(
				name: "Assign instance variables",
				body: @attributes.each_value.map do |attribute|
					Assignment.new(
						left: Ref.new("@#{attribute.name}"),
						right: Ref.new(attribute.escaped)
					)
				end
			)
		end
	end
end
