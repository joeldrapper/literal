# frozen_string_literal: true

class Literal::Array
	def initialize(value, type:)
		@value = value
		@type = type
	end

	attr_accessor :value, :type

	def <<(item)
		case item
		when @type
			@value << item
			self
		else
			raise Literal::TypeError, "Expected #{item.inspect} to be #{@type.inspect}."
		end
	end
end
