# frozen_string_literal: true

# @api private
class Literal::Types::SetType
	def initialize(type)
		@type = type
	end

	def inspect = "_Set(#{@type.inspect})"

	def ===(value)
		return false unless Set === value

		value.each do |v|
			return false unless @type === v
		end

		true
	end

	def record_literal_type_errors(context)
		return unless Set === context.actual

		context.actual.each do |actual|
			unless @type === actual
				context.add_child(label: "[]", expected: @type, actual:)
			end
		end
	end
end
