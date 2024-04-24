# frozen_string_literal: true

# @api private
module Literal::Types::AnyType
	extend self

	def inspect = "_Any"

	def ===(value)
		!(nil === value)
	end

	freeze
end
