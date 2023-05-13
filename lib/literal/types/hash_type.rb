# frozen_string_literal: true

class Literal::Types::HashType
	include Literal::Type

	def initialize(key_type, value_type)
		@key_type = key_type
		@value_type = value_type
	end

	def inspect
		"Hash(#{@key_type.inspect}, #{@value_type.inspect})"
	end

	def ===(value)
		value.is_a?(::Hash) && value.all? { |k, v| @key_type === k && @value_type === v }
	end
end
