# frozen_string_literal: true

# @api private
module Literal::Types::ProcableType
	extend self

	def inspect = "_Procable"

	def ===(value)
		Proc === value || value.respond_to?(:to_proc)
	end

	freeze
end
