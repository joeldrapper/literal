# frozen_string_literal: true

# @api private
class Literal::Types::JSONDataTypeClass
	include Literal::Type

	# This needs to be defined here so it can be referenced in the COMPATIBLE_TYPES constant.
	Literal::Types::JSONDataType = Literal::Types::JSONDataTypeClass.new.freeze

	COMPATIBLE_TYPES = Set[
		Integer,
		Float,
		String,
		true,
		false,
		nil,
		Literal::Types::BooleanType,
		Literal::Types::JSONDataType
	].freeze

	def inspect = "_JSONData"

	def ===(value)
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

	def record_literal_type_errors(context)
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

	def >=(other)
		return true if COMPATIBLE_TYPES.include?(other)

		case other
		when Literal::Types::ArrayType
			self >= other.type
		when Literal::Types::HashType
			(self >= other.key_type) && (self >= other.value_type)
		when Literal::Types::ConstraintType
			other.object_constraints.any? { |type| self >= type }
		else
			false
		end
	end

	freeze
end
