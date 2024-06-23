# frozen_string_literal: true

class Literal::Rails::StructuredDataType < ActiveModel::Type::Value
	def initialize(type)
		@type = type
		super()
	end

	def cast(value)
		value
	end

	def serialize(value)
		if @type === value
			value.to_h
		elsif value.nil?
			value
		else
			raise ArgumentError
		end
	end
end
