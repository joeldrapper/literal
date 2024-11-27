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

		@shape.each do |key, expected|
			unless context.actual.key?(key) || expected === nil
				context.add_child(label: "[#{key.inspect}]", expected:, actual: nil)
				next
			end

			actual = context.actual[key]
			unless expected === actual
				context.add_child(label: "[#{key.inspect}]", expected:, actual:)
			end
		end
	end
end
