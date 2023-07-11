# frozen_string_literal: true

module Literal::Attributes::Generators
	class DataInitializer < StructInitializer
		private

		def body
			[
				assign_schema,
				escape_keywords,
				coerce_attributes,
				assign_defaults,
				check_types,
				assign_values,
				initializer_callback,
				freeze_object
			]
		end

		def freeze_object
			Ref.new("freeze")
		end

		def mapping(attribute)
			Mapping.new(
				left: Symbol.new(attribute.name),
				right: Ref.new("#{attribute.escaped}.frozen? ? #{attribute.escaped} : #{attribute.escaped}.freeze")
			)
		end
	end
end
