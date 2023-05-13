# frozen_string_literal: true

class Literal::Result
	include Literal::Monad

	def initialize(value)
		@value = value
		freeze
	end

	# @yieldparam switch [Literal::Switch]
	def handle(&block)
		Literal::Switch.new(Literal::Success, Literal::Failure, &block).call(self, @value)
	end
end
