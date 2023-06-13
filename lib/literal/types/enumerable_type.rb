# frozen_string_literal: true

# @api private
class Literal::Types::EnumerableType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect = "_Enumerable(#{@type.inspect})"

	if Literal::EXPENSIVE_TYPE_CHECKS
		def ===(value)
			Enumerable === value && value.all? { |item| @type === item }
		end
	else
		def ===(value)
			Enumerable === value && @type === value.first
		end
	end
end
