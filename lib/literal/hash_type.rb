# frozen_string_literal: true

# @api private
class Literal::HashType < Literal::Generic
	def initialize(key_type, value_type)
		@key_type = key_type
		@value_type = value_type
	end

	def inspect = "Hash(#{@key_type}, #{@value_type})"

	def ===(value)
		case value
		when Literal::Hash
			@key_type == value.key_type && @value_type == value.value_type
		else
			false
		end
	end

	def new(value)
		Literal::Hash.new(value, key_type: @key_type, value_type: @value_type)
	end
end
