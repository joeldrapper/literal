# frozen_string_literal: true

class Literal::Types::UnionType
	include Literal::Type

	def initialize(*types)
		@types = types
	end

	def inspect
		"Union(#{@types.map(&:inspect).join(', ')})"
	end

	def ===(value)
		@types.any? { |type| type === value }
	end

	def nil?
		@types.any?(&:nil?)
	end
end
