# frozen_string_literal: true

class Literal::Rails::EnumType < ActiveModel::Type::Value
	def initialize(enum)
		@enum = enum
		super()
	end

	def type
		:literal_enum
	end

	def cast(value)
		case value
		when nil
			nil
		else
			@enum.coerce(value)
		end
	end

	def serialize(value)
		case value
		when nil
			nil
		else
			@enum.coerce(value).value
		end
	end

	def deserialize(value)
		case value
		when nil
			nil
		else
			@enum.coerce(value)
		end
	end
end
