# frozen_string_literal: true

class Literal::Right < Literal::Either::Option
	def left? = false
	def right? = true

	def inspect
		"Literal::Right(#{@value.inspect})"
	end
end
