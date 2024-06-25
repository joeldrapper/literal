# frozen_string_literal: true

class Literal::Rails::EnumType < ActiveModel::Type::Value
	def initialize(enum)
		@enum = enum
		super()
	end

	def cast(value)
		case value
		when @enum
			value
		else
			deserialize(value)
		end
	end

	def serialize(value)
		case value
		when @enum
			value.value
		else
			raise Literal::TypeError.expected(
				value, to_be_a: @enum
			)
		end
	end

	def deserialize(value)
		@enum[value] || raise ArgumentError.new("Invalid value: #{value.inspect} for #{@enum}")
	end
end
