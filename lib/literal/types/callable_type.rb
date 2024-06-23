# frozen_string_literal: true

# @api private
module Literal::Types::CallableType
	extend self

	def inspect = "_Callable"

	def ===(value)
		value.respond_to?(:call)
	end

	freeze
end
