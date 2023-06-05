# frozen_string_literal: true

Literal::Types::TruthyType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "_Truthy"

	def ===(value)
		!!value
	end
end
