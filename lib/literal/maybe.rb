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

	# @return [void]
	def handle(&)
		Literal::Switch.new(Literal::Some, Literal::Nothing, &)[self].call(@value)
	end
end
