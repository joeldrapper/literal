# frozen_string_literal: true

class Literal::EnumType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect
		"Literal::Enum(#{@type.inspect})"
	end

	def ===(value)
		Literal::Enum === value && value.type == @type
	end
end
