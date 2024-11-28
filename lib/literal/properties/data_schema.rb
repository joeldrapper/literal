# frozen_string_literal: true

class Literal::Properties::DataSchema < Literal::Properties::Schema
	def generate_after_initializer(buffer = +"")
		super
		buffer << "  freeze\n"
	end
end
