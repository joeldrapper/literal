# frozen_string_literal: true

class Literal::Failure < Literal::Result
	# @return [String]
	def inspect = "Literal::Failure(#{@value.inspect})"

	# @return [false]
	def success? = false

	# @return [true]
	def failure? = true

	# @return [Literal::NothingClass]
	def success = Literal::Nothing

	# @return [Literal::Some]
	def failure = Literal::Some(@value)

	def raise!
		raise @value
	end

	def value_or
		yield(@value)
	end

	def map = self
	def bind = self
	def then = self
	def filter = self

	def deconstruct
		[@value]
	end

	def deconstruct_keys(_)
		{ failure: @value }
	end
end
