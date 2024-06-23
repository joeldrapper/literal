# frozen_string_literal: true

class Literal::Properties::DataSchema < Literal::Properties::Schema
	def generate_initializer_body
		[
			super,
			"freeze",
		].join("\n")
	end
end
