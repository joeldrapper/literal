# frozen_string_literal: true

class Literal::Types::EnumerableType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	def inspect
		"Enumerable(#{@type.inspect})"
	end

	def ===(value)
		value.is_a?(::Enumerable) && value.all? { |item| @type === item }
	end
end
