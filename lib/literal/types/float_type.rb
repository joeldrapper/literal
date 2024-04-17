# frozen_string_literal: true

# @api private
class Literal::Types::FloatType
	def initialize(range)
		@range = range
	end

	def inspect = "_Float(#{@range})"

	def ===(value)
		Float === value && @range === value
	end

	def ==(other)
		self.class == other.class && @range == other.range
	end

	protected

	attr_reader :range
end
