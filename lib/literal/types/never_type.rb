# frozen_string_literal: true

# @api private
class Literal::Types::NeverTypeClass
	include Literal::Type

	def inspect
		"_Never"
	end

	def ===(value)
		false
	end

	def >=(other)
		case other
		when Literal::Types::NeverTypeClass
			true
		else
			false
		end
	end

	freeze
end

Literal::Types::NeverType = Literal::Types::NeverTypeClass.new.freeze
