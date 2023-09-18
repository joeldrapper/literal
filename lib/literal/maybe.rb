# frozen_string_literal: true

# @abstract
class Literal::Maybe < Literal::Monad
	# @return [void]
	def call(&)
		Literal::Case.new(Literal::Some, Literal::Nothing, &)[self].call(@value)
	end
end
