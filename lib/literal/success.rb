# frozen_string_literal: true

class Literal::Success < Literal::Result
	def failure? = false
	def success? = true

	def inspect
		"Literal::Success(#{@value.inspect})"
	end
end
