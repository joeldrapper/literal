# frozen_string_literal: true

Literal::Types::ProcableType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "Procable"

	def ===(other)
		(Proc === other) || other.respond_to?(:to_proc)
	end
end
