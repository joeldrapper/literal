# frozen_string_literal: true

# @api private
class Literal::Types::HashType
	def initialize(key_type, value_type)
		@key_type = key_type
		@value_type = value_type
	end

	def inspect = "_Hash(#{@key_type.inspect}, #{@value_type.inspect})"

	def ===(value)
		Hash === value && value.each do |k, v|
			return false unless @key_type === k && @value_type === v
		end
	end
end
