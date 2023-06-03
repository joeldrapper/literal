# frozen_string_literal: true

Literal::Types::TruthyType = Literal::Singleton.new do
	include Literal::Type

	def inspect
		"Truthy"
	end

	def ===(value)
		!!value
	end
end
