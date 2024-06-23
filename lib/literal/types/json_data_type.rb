# frozen_string_literal: true

# @api private
module Literal::Types::JSONDataType
	def self.inspect = "_JSONData"

	def self.===(value)
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

	freeze
end
