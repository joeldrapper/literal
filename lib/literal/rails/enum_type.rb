# frozen_string_literal: true

class Literal::Rails::EnumType < ActiveModel::Type::Value
	def initialize(enum, subtype)
		@enum = enum
		@subtype = subtype || ActiveModel::Type::Value.new
		super()
	end

	def type
		:literal_enum
	end

	def cast(value)
		case value
		when nil
			nil
		when @enum
			value
		else
			@enum.coerce(@subtype.cast(value))
		end
	end

	def serialize(value)
		case value
		when nil
			nil
		else
			@subtype.serialize(@enum.coerce(value).value)
		end
	end

	def deserialize(value)
		case value
		when nil
			nil
		else
			@enum.coerce(@subtype.deserialize(value))
		end
	end
end
