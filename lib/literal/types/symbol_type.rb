# frozen_string_literal: true

# @api private
class Literal::Types::SymbolType < Literal::Type
	def initialize(constraint)
		@constraint = constraint
	end

	def inspect = "_Symbol(#{@constraint.inspect})"

	def ===(value)
		Symbol === value && @constraint === value
	end
end
