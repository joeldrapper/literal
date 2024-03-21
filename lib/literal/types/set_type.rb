# frozen_string_literal: true

# @api private
class Literal::Types::SetType
	def initialize(type)
		@type = type
	end

	def inspect = "_Set(#{@type.inspect})"

	if Literal::EXPENSIVE_TYPE_CHECKS
		def ===(value)
			Set === value && value.all? { |item| @type === item }
		end
	else
		def ===(value)
			Set === value && (value.empty? || @type === value.first)
		end
	end
end
