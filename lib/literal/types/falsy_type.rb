# frozen_string_literal: true

Literal::Types::FalsyType = Literal::Singleton.new do
	include Literal::Type

	def inspect
		"Falsy"
	end

	def ===(value)
		!value
	end
end
