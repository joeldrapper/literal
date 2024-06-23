# frozen_string_literal: true

# @api private
module Literal::Types::ProcableType
	def self.inspect = "_Procable"

	def self.===(value)
		Proc === value || value.respond_to?(:to_proc)
	end

	freeze
end
