# frozen_string_literal: true

# @abstract
class Literal::Monad
	extend Literal::Modifiers

	abstract!

	# @!method map
	abstract :map

	# @!method then
	abstract :then

	# @!method maybe
	abstract :maybe

	# @!method filter
	abstract :filter

	# @!method handle
	# 	@return [void]
	# 	@yieldparam switch [Literal::Switch]
	abstract :handle

	# @!method value_or
	abstract :value_or

	def bind
		yield @value
	end
end
