# frozen_string_literal: true

# @api private
class Literal::Types::EnumerableType
	def initialize(type)
		@type = type
	end

	def inspect = "_Enumerable(#{@type.inspect})"

	if Literal::EXPENSIVE_TYPE_CHECKS
		def ===(value)
			Enumerable === value && value.all? { |item| @type === item }
		end
	else
		def ===(value)
			Enumerable === value && (value.empty? || @type === value.first)
		end
	end

	def ==(other)
		self.class == other.class && @type == other.type
	end
	alias_method :eql?, :==

	protected

	attr_reader :type
end
