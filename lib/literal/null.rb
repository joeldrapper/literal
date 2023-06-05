# frozen_string_literal: true

Literal::Null = Literal::Singleton.new do
	def nil? = true
end
