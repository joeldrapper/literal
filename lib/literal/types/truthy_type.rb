# frozen_string_literal: true

# @api private
module Literal::Types::TruthyType
	extend self

	def inspect = "_Truthy"

	def ===(value)
		!!value
	end

	freeze
end
