# frozen_string_literal: true

module Literal::Attributable::Generators
	class StructInitializer < Initializer
		private

		def body
			[
				assign_schema,
				init_attributes_ivar,
				handle_attributes,
				initializer_callback
			]
		end

		def init_attributes_ivar
			Assignment.new(
				left: Ref.new("@attributes"),
				right: Ref.new("{}")
			)
		end

		def assign_value(attribute)
			Assignment.new(
				left: Access.new(
					collection: Ref.new("@attributes"),
					key: Symbol.new(attribute.name)
				),
				right: Ref.new(attribute.escaped)
			)
		end
	end
end
