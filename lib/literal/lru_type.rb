# frozen_string_literal: true

class Literal::LRUType
	def initialize(key_type, value_type)
		@key_type = key_type
		@value_type = value_type
	end

	def ===(other)
		Literal::LRU === other && other.key_type == @key_type && other.value_type == @value_type
	end

	def new(max_size)
		Literal::LRU.new(max_size, key_type: @key_type, value_type: @value_type)
	end
end
