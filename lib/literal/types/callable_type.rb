# frozen_string_literal: true

# @api private
module Literal::Types::CallableType
	def self.inspect = "_Callable"

	def self.===(value)
		value.respond_to?(:call)
	end

	freeze
end
