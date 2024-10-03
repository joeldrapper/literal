# frozen_string_literal: true

# @api private
class Literal::Types::ArrayType
	def initialize(type)
		@type = type
	end

	def inspect = "_Array(#{@type.inspect})"

	def ===(value)
		Array === value && value.all?(@type)
	end

	def record_literal_type_errors(context)
		unless Array === context.actual
			return
		end

		context.actual.each_with_index do |item, index|
			unless @type === item
				context.add_child(label: "[#{index}]", expected: @type, actual: item)
			end
		end
	end
end
