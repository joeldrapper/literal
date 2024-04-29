# frozen_string_literal: true

# @api private
class Literal::Types::IntersectionType
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

	def ==(other)
		self.class == other.class && @types == other.types
	end
	alias_method :eql?, :==

	protected

	attr_reader :types
end
