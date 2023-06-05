# frozen_string_literal: true

class Literal::Right < Literal::Either
	# @return [false]
	def left? = false

	# @return [true]
	def right? = true

	# @return [Literal::NothingClass]
	def left = Literal::Nothing

	# @return [Literal::Some]
	def right = Literal::Some.new(@value)

	# @return [String]
	def inspect = "Literal::Right(#{@value.inspect})"
end
