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

	def curry_handle!(*args)
		result = self

		proc do |*a, &block|
			if block
				result.handle!(*args, *a, &block)
			else
				result.curry_handle!(*args, *a)
			end
		end
	end
end
