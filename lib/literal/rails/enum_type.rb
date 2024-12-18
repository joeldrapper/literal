# frozen_string_literal: true

class Literal::Rails::EnumType < ActiveModel::Type::Value
	def initialize(enum)
		@enum = enum
		super()
	end

	def cast(value)
		@enum.coerce(value)
	end

	def serialize(value)
		@enum.coerce(value).value || raise(
			Literal::ArgumentError.new("Invalid value: #{value.inspect}. Expected an #{@enum.inspect}.")
		)
	end

	def deserialize(value)
		case value
		when nil
			nil
		else
			@enum[value] || raise(
				ArgumentError.new("Invalid value: #{value.inspect} for #{@enum}")
			)
		end
	end
end
