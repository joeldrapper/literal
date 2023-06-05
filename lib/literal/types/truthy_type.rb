# frozen_string_literal: true

Literal::Types::TruthyType = Literal::Singleton.new(Literal::Type) do
	def inspect = "_Truthy"

	def ===(value)
		!!value
	end
end
