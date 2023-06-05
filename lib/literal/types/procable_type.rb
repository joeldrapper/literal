# frozen_string_literal: true

# @api private
Literal::Types::ProcableType = Literal::Singleton.new(Literal::Type) do
	def inspect = "_Procable"

	def ===(value)
		Proc === value || value.respond_to?(:to_proc)
	end
end
