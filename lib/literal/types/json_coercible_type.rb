# frozen_string_literal: true

Literal::Types::JSONCoercibleType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "_JSONCoercible"

	def ===(other)
		case other
		when Hash
			other.all? { |k, v| (String === k || Symbol === k) && self === v }
		when Array
			other.all? { |v| self === v }
		when String, Symbol, Integer, Float, Date, DateTime, true, false, nil # for performance
			true
		else
			other.respond_to?(:to_json)
		end
	end
end
