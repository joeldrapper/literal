# frozen_string_literal: true

# @api private
class Literal::Types::FrozenType
	def initialize(type)
		@type = type
	end

	def inspect = "_Frozen(#{@type.inspect})"

	def ===(value)
		value.frozen? && @type === value
	end

	def ==(other)
		self.class == other.class && @type == other.type
	end

	protected

	attr_reader :type
end
