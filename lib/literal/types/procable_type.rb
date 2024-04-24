# frozen_string_literal: true

# @api private
Literal::Types::ProcableType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Procable"

	def ===(value)
		Proc === value || value.respond_to?(:to_proc)
	end

	def ==(other)
		equal?(other)
	end
end
