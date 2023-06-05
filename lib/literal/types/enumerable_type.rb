# frozen_string_literal: true

class Literal::Types::EnumerableType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	def inspect = "_Enumerable(#{@type.inspect})"

	def ===(value)
		Enumerable === value && value.all? { |item| @type === item }
	end
end
