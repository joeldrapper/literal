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
		Enumerable === other && @shape.all? { |k, t| t === other[k] }
	end

	def ==(other)
		self.class == other.class && @shape == other.instance_variable_get(:@shape)
	end
	alias_method :eql?, :==
end
