# frozen_string_literal: true

# @api private
Literal::Types::TruthyType = Literal::Singleton.new(Literal::Type) do
	def initialize
		freeze
	end

	def inspect = "_Truthy"

	def ===(value)
		!!value
	end
end
