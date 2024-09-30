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
		when nil
			nil
		when @enum
			value.value
		else
			raise Literal::ArgumentError.new(
				"Invalid value: #{value.inspect}. Expected an #{@enum.inspect}.",
			)
		end
	end

	def deserialize(value)
		case value
		when nil
			nil
		else
			@enum[value] || raise(
				ArgumentError.new("Invalid value: #{value.inspect} for #{@enum}"),
			)
		end
	end
end
