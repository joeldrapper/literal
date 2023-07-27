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

	# @!method deconstruct
	abstract def deconstruct = nil

	# @!method deconstruct_keys(_)
	abstract def deconstruct_keys(_) = nil

	# @!method value_or_raise!
	abstract def value_or_raise! = nil

	def initialize(value)
		@value = value
		freeze
	end

	attr_accessor :value

	# @yieldparam switch [Literal::Case]
	def call(&)
		Literal::Case.new(Literal::Success, Literal::Failure, &)[self].call(@value)
	end
end
