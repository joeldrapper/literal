# frozen_string_literal: true

class Literal::FutureProxyType
	def initialize(type)
		@type = type
	end

	attr_reader :type

	def inspect
		"Literal::FutureProxy(#{@type.inspect})"
	end

	def ===(other)
		Literal::FutureProxy === other && @type == other.type
	end

	def new(&)
		Literal::FutureProxy.new(@type, Async(&))
	end
end
