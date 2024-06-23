# frozen_string_literal: true

# @api private
module Literal::Types::NeverType
	def self.inspect = "_Never"

	def self.===(value)
		false
	end

	freeze
end
