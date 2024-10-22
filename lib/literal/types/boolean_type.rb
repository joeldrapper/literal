# frozen_string_literal: true

# @api private
module Literal::Types::BooleanType
	def self.inspect = "_Boolean"

	def self.===(value)
		true == value || false == value
	end

	freeze
end
