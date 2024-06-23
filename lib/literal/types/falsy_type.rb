# frozen_string_literal: true

# @api private
module Literal::Types::FalsyType
	def self.inspect = "_Falsy"

	def self.===(value)
		!value
	end

	freeze
end
