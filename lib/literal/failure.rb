# frozen_string_literal: true

class Literal::Failure < Literal::Result
	def success? = false
	def failure? = true

	def inspect = "Literal::Failure(#{@value.inspect})"

	def raise! = raise @value

	def success = Literal::Nothing
	def failure = Literal::Some(@value)

	def map = self
	def bind = self
	def filter = self
end
