# frozen_string_literal: true

module Literal::Attributes::Generators
	class Base
		include Literal::Attributes::Nodes

		def call
			Literal::Attributes::Formatter.new.visit(template)
		end
	end
end
