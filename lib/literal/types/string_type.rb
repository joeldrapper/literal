# frozen_string_literal: true

# @api private
class Literal::Types::StringType
	def initialize(constraint)
		@constraint = constraint
	end

	def inspect = "_String(#{@constraint.inspect})"

	def ===(value)
		String === value && @constraint === value
	end

	def ==(other)
		self.class == other.class && @constraint == other.constraint
	end

	protected

	attr_reader :constraint
end
