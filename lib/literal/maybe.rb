# frozen_string_literal: true

# @abstract
class Literal::Maybe < Literal::Monad
	abstract!

	# @!method empty?
	# 	@return [Boolean]
	abstract def empty? = nil

	# @!method nothing?
	# 	@return [Boolean]
	abstract def nothing? = nil

	# @!method something?
	# 	@return [Boolean]
	abstract def something? = nil

	# @return [void]
	def handle(&)
		Literal::Switch.new(Literal::Some, Literal::Nothing, &).call(self, @value)
	end
end
