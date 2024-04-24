# frozen_string_literal: true

# @api private
class Literal::Types::SymbolType
	def initialize(constraint)
		@constraint = constraint
	end

	def inspect = "_Symbol(#{@constraint.inspect})"

	def ===(value)
		Symbol === value && @constraint === value
	end

	def ==(other)
		self.class == other.class && @constraint == other.constraint
	end

	protected

	attr_reader :constraint
end
