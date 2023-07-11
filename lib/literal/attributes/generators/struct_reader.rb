# frozen_string_literal: true

module Literal::Attributes::Generators
	class StructReader < Reader
		private

		def body
			[
				Access.new(
					collection: Ref.new("@attributes"),
					key: Symbol.new(@attribute.name)
				)
			]
		end
	end
end
