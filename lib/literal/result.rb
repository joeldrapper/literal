# frozen_string_literal: true

# @abstract
class Literal::Result < Literal::Monad
	def initialize(value)
		@value = value
		freeze
	end

	attr_accessor :value

	# @return [Array]
	def deconstruct
		[@value]
	end

	# @yieldparam switch [Literal::Case]
	def call(&)
		Literal::Case.new(Literal::Success, Literal::Failure, &)[self].call(@value)
	end
end
