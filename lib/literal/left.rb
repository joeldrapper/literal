# frozen_string_literal: true

class Literal::Left < Literal::Either::Option
	def left? = true
	def right? = false

	def inspect
		"Literal::Left(#{@value.inspect})"
	end
end
