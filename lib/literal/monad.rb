# frozen_string_literal: true

# @abstract
class Literal::Monad
	extend Literal::Modifiers

	abstract!

	# @!method map
	abstract :map

	# @!method then
	abstract :then

	# @!method filter
	abstract :filter

	# @!method handle
	# 	@return [void]
	# 	@yieldparam switch [Literal::Case]
	abstract :call

	# @!method value_or
	abstract :value_or

	def handle(...)
		call(...)
	end

	def bind
		yield @value
	end
end
