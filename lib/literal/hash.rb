# frozen_string_literal: true

class Literal::Hash
	def initialize(value, key_type:, value_type:)
		@value = value
		@key_type = key_type
		@value_type = value_type
	end

	attr_accessor :value, :key_type, :value_type

	def []=(key, value)
		if @key_type === key && @value_type === value
			@value[key] = value
		else
			raise Literal::TypeError
		end
	end
end
