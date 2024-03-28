# frozen_string_literal: true

# @api private
class Literal::Types::NilableType
	def initialize(type)
		@type = type
	end

	def inspect = "_Nilable(#{@type.inspect})"

	def ===(value)
		nil === value || @type === value
	end

	def ==(other)
		self.class == other.class && @type == other.type
	end

	protected

	attr_reader :type
end
