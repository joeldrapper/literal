# frozen_string_literal: true

class Literal::Array
	def initialize(value, type:)
		@value = value
		@type = type
	end

	attr_accessor :value, :type

	def <<(item)
		unless @type === item
			raise Literal::TypeError.expected(item, to_be_a: @type)
		end

		@value << item
		self
	end
end
