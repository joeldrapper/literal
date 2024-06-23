# frozen_string_literal: true

# @api private
module Literal::Types::LambdaType
	extend self

	def inspect = "_Lambda"

	def ===(value)
		Proc === value && value.lambda?
	end

	freeze
end
