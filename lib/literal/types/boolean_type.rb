# frozen_string_literal: true

# @api private
module Literal::Types::BooleanType
	COERCION = proc { |value| !!value }

	def self.inspect = "_Boolean"

	def self.===(value)
		true == value || false == value
	end

	def to_proc
		COERCION
	end

	freeze
end
