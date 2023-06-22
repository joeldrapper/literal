# frozen_string_literal: true

# @api private
class Literal::Types::HashType < Literal::Type
	def initialize(key_type, value_type)
		@key_type = key_type
		@value_type = value_type
	end

	def inspect = "_Hash(#{@key_type.inspect}, #{@value_type.inspect})"

	if Literal::EXPENSIVE_TYPE_CHECKS
		def ===(value)
			Hash === value && value.all? { |k, v| @key_type === k && @value_type === v }
		end
	else
		def ===(value)
			Hash === value && (value.empty? || (@key_type === value.each_key.first && @value_type === value.each_value.first))
		end
	end
end
