# frozen_string_literal: true

class Literal::TypeError < TypeError
	include Literal::Error

	def self.expected(value, to_be_a:)
		type = to_be_a
		new("Expected `#{value.inspect}` to be of type: `#{type.inspect}`.")
	end
end
