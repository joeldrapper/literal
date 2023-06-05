# frozen_string_literal: true

Literal::Types::FalsyType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "_Falsy"

	def ===(value)
		!value
	end
end
