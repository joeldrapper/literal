# frozen_string_literal: true

# @abstract
class Literal::Result < Literal::Monad
	abstract!

	# @!method inspect
	# 	@return [String]
	abstract :inspect

	# @!method success?
	# 	@return [Boolean]
	abstract :success?

	# @!method failure?
	# 	@return [Boolean]
	abstract :failure?

	# @!method success
	# 	@return [Literal::Maybe]
	abstract :success

	# @!method failure
	# 	@return [Literal::Maybe]
	abstract :failure

	# @!method raise!
	abstract :raise!

	def initialize(value)
		@value = value
		freeze
	end

	# @yieldparam switch [Literal::Switch]
	def handle(&)
		Literal::Switch.new(Literal::Success, Literal::Failure, &).call(self, @value)
	end
end
