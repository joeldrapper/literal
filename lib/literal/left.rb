# frozen_string_literal: true

class Literal::Left < Literal::Either
	# @return [true]
	def left? = true

	# @return [false]
	def right? = false

	# @return [Literal::Some]
	def left = Literal::Some.new(@value)

	# @return [Literal::NothingClass]
	def right = Literal::Nothing

	# @return [String]
	def inspect = "Literal::Left(#{@value.inspect})"
end
