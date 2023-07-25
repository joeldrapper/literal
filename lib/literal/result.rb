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

	# @!method deconstruct
	abstract :deconstruct

	# @!method deconstruct_keys(_)
	abstract :deconstruct_keys

	def initialize(value)
		@value = value
		freeze
	end

	attr_accessor :value

	# @yieldparam switch [Literal::Case]
	def call(&)
		Literal::Variant(Literal::Success, Literal::Failure).new(self).call(&)
	end
end
