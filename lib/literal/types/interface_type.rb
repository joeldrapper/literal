# frozen_string_literal: true

# @api private
class Literal::Types::InterfaceType
	def initialize(*methods)
		raise Literal::ArgumentError.new("_Interface type must have at least one method.") if methods.size < 1
		@methods = methods
	end

	attr_reader :methods

	def inspect = "_Interface(#{@methods.map(&:inspect).join(', ')})"

	def ===(value)
		@methods.all? { |m| value.respond_to?(m) }
	end
end
