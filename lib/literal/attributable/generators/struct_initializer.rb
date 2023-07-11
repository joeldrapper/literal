# frozen_string_literal: true

module Literal::Attributable::Generators
	class StructInitializer < Initializer
		private

		def assign_values
			Section.new(
				name: "Assign hash attributes",
				body: [
					Assignment.new(
						left: Ref.new("@attributes"),
						right: HashLiteral.new(
							@attributes.each_value.map { |a| mapping(a) }
						)
					)
				]
			)
		end

		def mapping(attribute)
			Mapping.new(
				left: Symbol.new(attribute.name),
				right: Ref.new(attribute.escaped)
			)
		end
	end
end
