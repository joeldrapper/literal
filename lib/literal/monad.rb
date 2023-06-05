# frozen_string_literal: true

# @abstract
class Literal::Monad
	extend Literal::Modifiers

	abstract!

	abstract def map = nil
	abstract def then = nil
	abstract def maybe = nil
	abstract def filter = nil
	abstract def handle = nil
	abstract def value_or = nil

	def bind
		yield @value
	end
end
