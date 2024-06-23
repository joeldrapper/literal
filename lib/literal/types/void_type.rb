# frozen_string_literal: true

# @api private
module Literal::Types::VoidType
	def self.inspect = "_Void"

	def self.===(_)
		true
	end

	freeze
end
