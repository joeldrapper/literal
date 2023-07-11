# frozen_string_literal: true

module Literal::Attributable::Generators
	class Base
		include Literal::Attributable::Nodes

		def call
			Literal::Attributable::Formatter.new.visit(template)
		end
	end
end
