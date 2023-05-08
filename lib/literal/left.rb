# frozen_string_literal: true

class Literal::Left < Literal::Either
	def left? = true
	def right? = false

	def left = Literal::Some.new(@value)
	def right = Literal::Nothing

	def inspect = "Literal::Left(#{@value.inspect})"
end
