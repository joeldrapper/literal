# frozen_string_literal: true

# @api private
class Literal::Types::AnyTypeClass
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

	freeze
end

Literal::Types::AnyType = Literal::Types::AnyTypeClass.new.freeze
