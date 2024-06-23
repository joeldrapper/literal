# frozen_string_literal: true

# @api private
module Literal::Types::BooleanType
	extend self

	def inspect = "_Boolean"

	def ===(value)
		true == value || false == value
	end

	freeze
end
