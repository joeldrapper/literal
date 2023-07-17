# frozen_string_literal: true

module Literal::Attributable::Generators
	class IVarInitializer < Initializer
		private

		def assign_value(attribute)
			Assignment.new(
				left: Ref.new("@#{attribute.name}"),
				right: Ref.new(attribute.escaped)
			)
		end
	end
end
