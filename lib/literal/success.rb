# frozen_string_literal: true

class Literal::Success < Literal::Result
	def initialize(value)
		@value = value
	end
end
