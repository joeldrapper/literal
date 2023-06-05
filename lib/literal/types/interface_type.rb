# frozen_string_literal: true

# @api private
class Literal::Types::InterfaceType < Literal::Type
	def initialize(*methods)
		@methods = methods
	end

	def inspect = "_Interface(#{@methods.map(&:inspect).join(', ')})"

	def ===(value)
		@methods.all? { |m| value.respond_to?(m) }
	end
end
