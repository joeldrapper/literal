# frozen_string_literal: true

Literal::Types::FalsyType = Literal::Singleton.new(Literal::Type) do
	def inspect = "_Falsy"

	def ===(value)
		!value
	end
end
