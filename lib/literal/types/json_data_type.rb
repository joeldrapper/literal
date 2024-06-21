# frozen_string_literal: true

# @api private
Literal::Types::JSONDataType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_JSONData"

	def ===(value)
		case value
		when String, Integer, Float, true, false, nil
			true
		when Hash
			value.all? { |k, v| String === k && self === v }
		when Array
			value.all? { |v| self === v }
		else
			false
		end
	end
end
