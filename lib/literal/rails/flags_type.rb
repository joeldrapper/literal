# frozen_string_literal: true

class Literal::Rails::FlagsType < ActiveModel::Type::Value
	def initialize(flags_class)
		@flags_class = flags_class
		super()
	end

	def cast(value)
		case value
		when @flags_class
			value
		else
			deserialize(value)
		end
	end

	def serialize(value)
		case value
		when nil
			nil
		when @flags_class
			value.to_bit_string
		else
			raise Literal::ArgumentError.new(
				"Invalid value: #{value.inspect}. Expected an #{@flags_class.inspect}.",
			)
		end
	end

	def deserialize(value)
		case value
		when nil
			nil
		else
			@flags_class.from_bit_string(value) || raise(
				ArgumentError.new("Invalid value: #{value.inspect} for #{@flags_class}"),
			)
		end
	end
end
