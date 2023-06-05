# frozen_string_literal: true

Literal::Types::JSONCoercibleType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "_JSONCoercible"

	if Literal::EXPENSIVE_TYPE_CHECKS
		def ===(value)
			case value
			when Hash
				value.all? { |k, v| (String === k || Symbol === k) && self === v }
			when Array
				value.all? { |v| self === v }
			when String, Symbol, Integer, Float, Date, DateTime, true, false, nil # for performance
				true
			else
				value.respond_to?(:to_json)
			end
		end
	else
		def ===(value)
			case value
			when Hash, Array, String, Symbol, Integer, Float, Date, DateTime, true, false, nil # for performance
				true
			else
				value.respond_to?(:to_json)
			end
		end
	end
end
