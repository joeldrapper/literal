# frozen_string_literal: true

module Literal::Attributable::Generators
	class DataInitializer < StructInitializer
		private

		def body
			[
				assign_schema,
				init_attributes_ivar,
				handle_attributes,
				initializer_callback,
				freeze_object
			]
		end

		def freeze_object
			Ref.new("freeze")
		end

		def assign_value(attribute)
			Assignment.new(
				left: Access.new(
					collection: Ref.new("@attributes"),
					key: Symbol.new(attribute.name)
				),
				right: Ref.new("#{attribute.escaped}.frozen? ? #{attribute.escaped} : #{attribute.escaped}.freeze")
			)
		end
	end
end
