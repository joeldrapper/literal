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
		@shape.all? { |k, t| t === other[k] }
	end

	def check(value, &blk)
		Literal.check(value, Hash, &blk)
		value.each do |key, item|
			type = @shape[key]
			Literal.check(item, type) do |c|
				blk.call c.nest(+"[" << key.inspect << "]", expected: type, actual: item)
			end
		end
	end
end
