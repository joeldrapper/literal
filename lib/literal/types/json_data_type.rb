# frozen_string_literal: true

Literal::Types::JSONDataType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "_JSONData"

	def ===(other)
		case other
		when String, Integer, Float, true, false, nil
			true
		when Hash
			other.all? { |k, v| String === k && self === v }
		when Array
			other.all? { |v| self === v }
		else
			false
		end
	end
end
