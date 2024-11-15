# frozen_string_literal: true

# @api private
class Literal::Types::ClassType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	attr_reader :type

	def inspect
		"_Class(#{@type.name})"
	end

	def ===(value)
		Class === value && (value == @type || value < @type)
	end

	def >=(other)
		case other
		when Literal::Types::ClassType
			Literal.subtype?(other.type, of: @type)
		when Literal::Types::DescendantType
			(Class === other.type) && Literal.subtype?(other.type, of: @type)
		else
			false
		end
	end

	freeze
end
