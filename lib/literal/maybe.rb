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

	# @!method deconstruct
	abstract def deconstruct = nil

	# @!method deconstruct_keys(_)
	abstract def deconstruct_keys(_) = nil

	# @return [void]
	def call(&)
		Literal::Case.new(Literal::Some, Literal::Nothing, &)[self].call(@value)
	end
end
