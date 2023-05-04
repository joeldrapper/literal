# frozen_string_literal: true

class Literal::Types::SetType
	def initialize(type)
		@type = type
	end

	def inspect
		"Set(#{@type.inspect})"
	end

	def ===(value)
		value.is_a?(::Set) && value.all? { |item| @type === item }
	end
end
