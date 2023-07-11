# frozen_string_literal: true

module Literal::Attributable::Generators
	class IVarReader < Reader
		private

		def body
			[
				Ref.new("@#{@attribute.name}")
			]
		end
	end
end
