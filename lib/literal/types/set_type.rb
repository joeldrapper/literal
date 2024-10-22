# frozen_string_literal: true

# @api private
class Literal::Types::SetType
	def initialize(type)
		@type = type
	end

	def inspect = "_Set(#{@type.inspect})"

	def ===(value)
		return false unless Set === value

		value.each do |v|
			return false unless @type === v
		end

		true
	end
end
