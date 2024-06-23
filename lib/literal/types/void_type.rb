# frozen_string_literal: true

# @api private
module Literal::Types::VoidType
	extend self

	def inspect = "_Void"

	def ===(_)
		true
	end

	freeze
end
