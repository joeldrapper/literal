# frozen_string_literal: true

# @api private
class Literal::Types::RangeType
	def initialize(type)
		@type = type
	end

	def inspect = "_Range(#{@type.inspect})"

	def ===(value)
		Range === value && (
			(
				@type === value.begin && (nil === value.end || @type === value.end)
			) || (
				@type === value.end && nil === value.begin
			)
		)
	end

	def ==(other)
		self.class == other.class && @type == other.type
	end

	protected

	attr_reader :type
end
