# frozen_string_literal: true

# @api private
class Literal::Types::SetType
	def initialize(type)
		@type = type
	end

	def inspect = "_Set(#{@type.inspect})"

	def ===(value)
		Set === value && value.all? { |item| @type === item }
	end
end
