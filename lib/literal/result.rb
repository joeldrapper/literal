# frozen_string_literal: true

class Literal::Result < Literal::Monad
	abstract!

	abstract def success? = nil
	abstract def failure? = nil

	abstract def success = nil
	abstract def failure = nil

	abstract def raise! = nil

	def initialize(value)
		@value = value
		freeze
	end

	# @yieldparam switch [Literal::Switch]
	def handle(&block)
		Literal::Switch.new(Literal::Success, Literal::Failure, &block).call(self, @value)
	end
end
