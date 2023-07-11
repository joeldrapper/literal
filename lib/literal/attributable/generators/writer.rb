# frozen_string_literal: true

module Literal::Attributable::Generators
	class Writer < Base
		def initialize(attribute)
			@attribute = attribute
		end

		def template
			Def.new(
				visibility: @attribute.writer,
				name: "#{@attribute.name}=",
				params:,
				body:
			)
		end

		private

		def params
			[
				PositionalParam.new(
					name: "value",
					default: nil
				)
			]
		end

		def body
			[type_check, assignment]
		end

		def type_check
			TypeCheck.new(
				attribute_name: @attribute.name,
				variable_name: "value"
			)
		end
	end
end
