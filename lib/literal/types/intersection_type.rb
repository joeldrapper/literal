# frozen_string_literal: true

class Literal::Types::IntersectionType < Literal::Type
	def initialize(*types)
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
