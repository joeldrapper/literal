# frozen_string_literal: true

class Literal::Types::NilableType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect = "_Nilable(#{@type.inspect})"

	def ===(value)
		nil === value || @type === value
	end
end
