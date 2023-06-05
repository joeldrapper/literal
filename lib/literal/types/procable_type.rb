# frozen_string_literal: true

Literal::Types::ProcableType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "_Procable"

	def ===(value)
		Proc === value || value.respond_to?(:to_proc)
	end
end
