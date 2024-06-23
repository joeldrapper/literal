# frozen_string_literal: true

# @api private
module Literal::Types::FalsyType
	extend self

	def inspect = "_Falsy"

	def ===(value)
		!value
	end

	freeze
end
