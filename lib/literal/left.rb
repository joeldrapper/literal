# frozen_string_literal: true

class Literal::Left < Literal::Either
	def left? = true
	def right? = false

	def inspect
		"Literal::Left(#{@value.inspect})"
	end
end
