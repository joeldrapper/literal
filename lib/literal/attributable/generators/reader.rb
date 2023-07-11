# frozen_string_literal: true

module Literal::Attributable::Generators
	class Reader < Base
		def initialize(attribute)
			@attribute = attribute
		end

		def template
			Def.new(
				visibility: @attribute.reader,
				name: @attribute.name,
				params: nil,
				body:
			)
		end
	end
end
