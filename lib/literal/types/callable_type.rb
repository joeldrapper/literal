# frozen_string_literal: true

# @api private
Literal::Types::CallableType = Literal::Singleton.new(Literal::Type) do
	def initialize
		freeze
	end

	def inspect = "_Callable"

	def ===(value)
		value.respond_to?(:call)
	end
end
