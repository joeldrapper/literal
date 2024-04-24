# frozen_string_literal: true

# @api private
class Literal::Types::ArrayType
	def initialize(type)
		@type = type
	end

	def inspect = "_Array(#{@type.inspect})"

	if Literal::EXPENSIVE_TYPE_CHECKS
		def ===(value)
			Array === value && value.all? { |item| @type === item }
		end
	else
		def ===(value)
			Array === value && (value.empty? || @type === value[0])
		end
	end

	def ==(other)
		self.class == other.class && @type == other.type
	end
	alias_method :eql?, :==

	protected

	attr_reader :type
end
