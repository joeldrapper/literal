# frozen_string_literal: true

class Literal::Maybe < Literal::Monad
	abstract_class!

	abstract_method :empty?
	abstract_method :nothing?
	abstract_method :something?

	def handle(&block)
		Literal::Switch.new(Literal::Some, Literal::Nothing, &block).call(self, @value)
	end
end
