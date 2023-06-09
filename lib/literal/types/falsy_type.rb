# frozen_string_literal: true

# @api private
Literal::Types::FalsyType = Literal::Singleton.new(Literal::Type) do
	def initialize
		freeze
	end

	def inspect = "_Falsy"

	def ===(value)
		!value
	end
end
