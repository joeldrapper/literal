# frozen_string_literal: true

# @abstract
class Literal::Result < Literal::Monad
	abstract!

	# @!method inspect
	# 	@return [String]
	abstract def inspect = nil

	# @!method success?
	# 	@return [Boolean]
	abstract def success? = nil

	# @!method failure?
	# 	@return [Boolean]
	abstract def failure? = nil

	# @!method success
	# 	@return [Literal::Maybe]
	abstract def success = nil

	# @!method failure
	# 	@return [Literal::Maybe]
	abstract def failure = nil

	# @!method raise!
	abstract def raise! = nil

	def initialize(value)
		@value = value
		freeze
	end

	# @yieldparam switch [Literal::Switch]
	def handle(&)
		Literal::Switch.new(Literal::Success, Literal::Failure, &).call(self, @value)
	end
end
