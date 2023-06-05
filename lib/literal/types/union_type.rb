# frozen_string_literal: true

# @api private
class Literal::Types::UnionType < Literal::Type
	def initialize(*types)
		@types = types
	end

	def inspect = "_Union(#{@types.map(&:inspect).join(', ')})"

	def ===(value)
		@types.any? { |type| type === value }
	end

	def nil?
		@types.any?(&:nil?)
	end
end
