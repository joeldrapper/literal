# frozen_string_literal: true

# @api private
module Literal::Types::AnyType
	def self.inspect = "_Any"

	def self.===(value)
		!(nil === value)
	end

	freeze
end
