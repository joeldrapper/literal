# frozen_string_literal: true

class Literal::Result
	def initialize(value)
		@value = value
		freeze
	end

	def handle(&block)
		Literal::Switch.new(Literal::Success, Literal::Failure, &block).call(self, @value)
	end
end
