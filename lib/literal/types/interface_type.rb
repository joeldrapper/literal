# frozen_string_literal: true

# @api private
class Literal::Types::InterfaceType
	def initialize(*methods)
		@methods = methods
	end

	def inspect = "_Interface(#{@methods.map(&:inspect).join(', ')})"

	def ===(value)
		@methods.all? { |m| value.respond_to?(m) }
	end

	def ==(other)
		self.class == other.class && @methods == other.instance_variable_get(:@methods)
	end
	alias_method :eql?, :==
end
