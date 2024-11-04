# frozen_string_literal: true

# @api private
class Literal::Types::HashType
	def initialize(key_type, value_type)
		@key_type = key_type
		@value_type = value_type
	end

	def inspect = "_Hash(#{@key_type.inspect}, #{@value_type.inspect})"

	def ===(value)
		return false unless Hash === value

		value.each do |k, v|
			return false unless @key_type === k && @value_type === v
		end

		true
	end

	def record_literal_type_errors(context)
		unless Hash === context.actual
			return
		end

		context.actual.each do |key, item|
			unless @key_type === key
				context.add_child(label: "[]", expected: @key_type, actual: key)
				next
			end

			unless @value_type === item
				context.add_child(label: "[#{key.inspect}]", expected: @value_type, actual: item)
			end
		end
	end
end
