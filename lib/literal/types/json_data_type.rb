# frozen_string_literal: true

# @api private
Literal::Types::JSONDataType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_JSONData"

	if Literal::EXPENSIVE_TYPE_CHECKS
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
	else
		def ===(value)
			case value
			when Hash, Array, String, Integer, Float, true, false, nil
				true
			else
				false
			end
		end
	end

	alias_method :==, :equal?
	alias_method :eql?, :==
end
