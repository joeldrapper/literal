# frozen_string_literal: true

module Literal::Attributable::Generators
	class StructWriter < Writer
		private

		def assignment
			Assignment.new(
				left: Access.new(
					collection: Ref.new("@attributes"),
					key: Symbol.new(@attribute.name)
				),
				right: Ref.new("value")
			)
		end
	end
end
