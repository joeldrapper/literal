# frozen_string_literal: true

# @api private
class Literal::Types::NotType
	def initialize(type)
		@type = type
	end

	def inspect = "_Not(#{@type.inspect})"

	def ===(value)
		!(@type === value)
	end

	def ==(other)
		self.class == other.class && @type == other.type
	end

	protected

	attr_reader :type
end
