# frozen_string_literal: true

module Literal::Attributable::Generators
	class IVarWriter < Writer
		private

		def assignment
			Assignment.new(
				left: Ref.new("@#{@attribute.name}"),
				right: Ref.new("value")
			)
		end
	end
end
