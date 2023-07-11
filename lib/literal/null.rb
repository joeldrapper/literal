# frozen_string_literal: true

Literal::Null = Literal::Singleton.new do
	def inspect
		"Literal::Null"
	end
end
