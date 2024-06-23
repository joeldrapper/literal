# frozen_string_literal: true

# @api private
module Literal::Types::LambdaType
	def self.inspect = "_Lambda"

	def self.===(value)
		Proc === value && value.lambda?
	end

	freeze
end
