# frozen_string_literal: true

class Literal::Result < Literal::Monad
	abstract_class!

	abstract_method :success?
	abstract_method :failure?

	abstract_method :success
	abstract_method :failure

	abstract_method :raise!

	def initialize(value)
		@value = value
		freeze
	end

	# @yieldparam switch [Literal::Switch]
	def handle(&block)
		Literal::Switch.new(Literal::Success, Literal::Failure, &block).call(self, @value)
	end
end
