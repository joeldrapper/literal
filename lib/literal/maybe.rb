# frozen_string_literal: true

# @abstract
class Literal::Maybe < Literal::Monad
	abstract!

	# @!method empty?
	# 	@return [Boolean]
	abstract :empty?

	# @!method nothing?
	# 	@return [Boolean]
	abstract :nothing?

	# @!method something?
	# 	@return [Boolean]
	abstract :something?

	# @!method deconstruct
	abstract :deconstruct

	# @!method deconstruct_keys(_)
	abstract :deconstruct_keys

	# @!method maybe
	abstract :maybe

	# @return [void]
	def call(&)
		Literal::Variant(Literal::Some, Literal::Nothing).new(self).call(&)
	end
end
