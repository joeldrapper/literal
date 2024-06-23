# frozen_string_literal: true

class Literal::Rails::EnumType < ActiveModel::Type::Value
	def initialize(enum)
		@enum = enum
		super()
	end

	def cast(value)
		value
	end

	def serialize(value)
		if @enum === value
			value.value
		elsif value.nil?
			value
		else
			raise ArgumentError
		end
	end

	def deserialize(value)
		@enum[value]
	end
end
