# frozen_string_literal: true

# @api private
module Literal::Types::JSONDataType
	def self.inspect = "_JSONData"

	def self.===(value)
		case value
		when String, Integer, Float, true, false, nil
			true
		when Hash
			value.each do |k, v|
				return false unless String === k && self === v
			end
		when Array
			value.all?(self)
		else
			false
		end
	end

	freeze
end
