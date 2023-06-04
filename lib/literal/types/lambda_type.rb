# frozen_string_literal: true

Literal::Types::LambdaType = Literal::Singleton.new do
	include Literal::Type

	def inspect = "Lambda"

	def ===(other)
		(Proc === other) && other.lambda?
	end
end
