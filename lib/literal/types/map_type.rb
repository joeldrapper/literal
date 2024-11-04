# frozen_string_literal: true

# @api private
class Literal::Types::MapType
	def initialize(**shape)
		@shape = shape
	end

	def inspect
		"_Map(#{@shape.inspect})"
	end

	def ===(other)
		Hash === other && @shape.each do |k, v|
			return false unless v === other[k]
		end
	end

	def record_literal_type_errors(context)
		unless Hash === context.actual
			return
		end

		context.actual.each do |key, item|
			unless (expected = @shape[key])
				context.add_child(label: "[]", expected: @shape.keys, actual: key)
				next
			end

			unless expected === item
				context.add_child(label: "[#{key.inspect}]", expected:, actual: item)
			end
		end
	end
end
