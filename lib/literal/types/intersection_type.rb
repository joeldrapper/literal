# frozen_string_literal: true

class Literal::Types::IntersectionType
	def initialize(*types)
		@types = types
	end

	def inspect
		"Intersection(#{@types.map(&:inspect).join(', ')})"
	end

	def ===(value)
		@types.all? { |type| type === value }
	end

	def nil?
		@types.all?(&:nil?)
	end
end
