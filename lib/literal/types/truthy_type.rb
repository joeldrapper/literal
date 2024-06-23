# frozen_string_literal: true

# @api private
module Literal::Types::TruthyType
	def self.inspect = "_Truthy"

	def self.===(value)
		!!value
	end

	freeze
end
