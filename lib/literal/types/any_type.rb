# frozen_string_literal: true

# @api private
class Literal::Types::AnyType
	include Literal::Type

	def inspect
		"_Any"
	end

	def ===(value)
		!(nil === value)
	end

	def >=(other)
		!(other === nil)
	end

	Instance = new.freeze

	freeze
end
