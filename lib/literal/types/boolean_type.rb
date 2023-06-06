# frozen_string_literal: true

# @api private
Literal::Types::BooleanType = Literal::Singleton.new(Literal::Type) do
	def initialize
		freeze
	end

	def inspect = "_Boolean"

	def ===(value)
		true == value || false == value
	end
end
