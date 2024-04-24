# frozen_string_literal: true

class Literal::Types::DescendantType
	def initialize(type)
		@type = type
	end

	def inspect = "_Descendant(#{@type})"

	def ===(value)
		Module === value && value < @type
	end

	def ==(other)
		self.class == other.class && @type == other.type
	end

	protected

	attr_reader :type
end
