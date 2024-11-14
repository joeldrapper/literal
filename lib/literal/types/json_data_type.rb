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

	def self.record_literal_type_errors(context)
		case value = context.actual
		when String, Integer, Float, true, false, nil
			# nothing to do
		when Hash
			value.each do |k, v|
				context.add_child(label: "[]", expected: String, actual: k) unless String === k
				context.add_child(label: "[#{k.inspect}]", expected: self, actual: v) unless self === v
			end
		when Array
			value.each_with_index do |item, index|
				context.add_child(label: "[#{index}]", expected: self, actual: item) unless self === item
			end
		end
	end

	freeze
end
