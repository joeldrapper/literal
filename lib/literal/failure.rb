# frozen_string_literal: true

class Literal::Failure < Literal::Result
	def inspect = "Literal::Failure(#{@value.inspect})"

	def success? = false
	def failure? = true

	def success = Literal::Nothing
	def failure = Literal::Some(@value)

	def raise!
		raise @value
	end

	def value_or
		yield
	end

	def map = self
	def bind = self
	def then = self
	def maybe = self
	def filter = self
end
