# frozen_string_literal: true

class Literal::Types::InterfaceType
	def initialize(*methods)
		@methods = methods
	end

	def inspect
		"Interface(#{@methods.map(&:inspect).join(', ')})"
	end

	def ===(other)
		@methods.all? { |m| other.respond_to?(m) }
	end
end
