# frozen_string_literal: true

# @api private
class Literal::LRUType < Literal::Generic
	def initialize(key_type, value_type)
		@key_type = key_type
		@value_type = value_type
	end

	def inspect = "Literal::LRU(#{@key_type.inspect}, #{@value_type.inspect})"

	def ===(other)
		Literal::LRU === other && other.key_type == @key_type && other.value_type == @value_type
	end

	def new(max_size)
		Literal::LRU.new(max_size, key_type: @key_type, value_type: @value_type)
	end
end
