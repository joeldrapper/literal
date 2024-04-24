# frozen_string_literal: true

# @api private
module Literal::Types::NeverType
	extend self

	def inspect = "_Never"

	def ===(value)
		false
	end

	freeze
end
