# frozen_string_literal: true

class Literal::Right < Literal::Either
	def left? = false
	def right? = true

	def left = Literal::Nothing
	def right = Literal::Some.new(@value)

	def inspect = "Literal::Right(#{@value.inspect})"
end
