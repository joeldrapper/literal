# frozen_string_literal: true

class Literal::Value
	attr_reader :value

	def inspect
		"#{self.class.name}(#{@value.inspect})"
	end

	def ===(other)
		self.class === other && @value == other.value
	end
end
