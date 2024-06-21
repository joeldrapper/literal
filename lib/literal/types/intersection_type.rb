# frozen_string_literal: true

# @api private
class Literal::Types::IntersectionType
	def initialize(*types)
		raise Literal::ArgumentError.new("_Intersection type must have at least one type.") if types.size < 1

		@types = types
	end

	def inspect = "_Intersection(#{@types.map(&:inspect).join(', ')})"

	def ===(value)
		@types.all? { |type| type === value }
	end

	def nil?
		@types.all?(&:nil?)
	end
end
