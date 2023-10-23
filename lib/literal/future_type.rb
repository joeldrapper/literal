# frozen_string_literal: true

class Literal::FutureType
	def initialize(type)
		@type = type
	end

	def inspect
		"Literal::Future(#{@type.inspect})"
	end

	def ===(other)
		Literal::Future === other && @type == other.type
	end

	def new(&)
		Literal::Future.new(@type, Async(&))
	end
end
