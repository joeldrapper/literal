# frozen_string_literal: true

# @api private
Literal::Types::LambdaType = Literal::Singleton.new(Literal::Type) do
	def initialize
		freeze
	end

	def inspect = "_Lambda"

	def ===(value)
		Proc === value && value.lambda?
	end
end
