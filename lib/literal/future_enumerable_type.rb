# frozen_string_literal: true

class Literal::FutureEnumerableType
	def initialize(type)
		@type = type
	end

	def inspect
		"Literal::FutureEnumerable(#{@type.inspect})"
	end

	def ===(other)
		Literal::FutureEnumerable === other && @type == other.type
	end

	def new(&)
		Literal::FutureEnumerable.new(@type, Async(&))
	end
end
