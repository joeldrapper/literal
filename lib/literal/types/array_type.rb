# frozen_string_literal: true

# @api private
class Literal::Types::ArrayType
	def initialize(type)
		@type = type
	end

	def inspect = "_Array(#{@type.inspect})"

	def ===(value)
		Array === value && value.all? { |item| @type === item }
	end
end
