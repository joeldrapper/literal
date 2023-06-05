# frozen_string_literal: true

Literal::Types::LambdaType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "_Lambda"

	def ===(value)
		Proc === value && value.lambda?
	end
end
