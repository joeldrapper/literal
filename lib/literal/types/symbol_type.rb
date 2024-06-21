# frozen_string_literal: true

# @api private
class Literal::Types::SymbolType < Literal::Types::ConstraintType
	def inspect = "_Symbol(#{@constraint.inspect})"

	def ===(value)
		Symbol === value && super
	end
end
