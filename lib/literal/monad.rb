# frozen_string_literal: true

# @abstract
class Literal::Monad
	extend Literal::Modifiers

	abstract!

	# @!method map
	abstract def map = nil

	# @!method then
	abstract def then = nil

	# @!method maybe
	abstract def maybe = nil

	# @!method filter
	abstract def filter = nil

	# @!method handle
	# 	@return [void]
	# 	@yieldparam switch [Literal::Switch]
	abstract def handle = nil

	# @!method value_or
	abstract def value_or = nil

	def bind
		yield @value
	end
end
