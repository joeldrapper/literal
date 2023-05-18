# frozen_string_literal: true

class Literal::Maybe < Literal::Monad
	abstract!

	abstract def empty? = nil
	abstract def nothing? = nil
	abstract def something? = nil

	def handle(&)
		Literal::Switch.new(Literal::Some, Literal::Nothing, &).call(self, @value)
	end
end
