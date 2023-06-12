# frozen_string_literal: true

# @api private
Literal::Types::VoidType = Literal::Singleton.new(Literal::Type) do
	def initialize
		freeze
	end

	def inspect = "_Void"

	def ===(_value)
		true
	end
end
