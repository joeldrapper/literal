# frozen_string_literal: true

# @api private
Literal::Types::AnyType = Literal::Singleton.new(Literal::Type) do
	def initialize
		freeze
	end

	def inspect = "_Any"

	def ===(value)
		!value.nil?
	end
end
