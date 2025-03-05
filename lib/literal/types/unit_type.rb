# frozen_string_literal: true

class Literal::Types::UnitType
	extend Literal::Type

	def initialize(type)
		@type = type
		freeze
	end

	def ===(other)
		@type.equal?(other)
	end

	freeze
end
