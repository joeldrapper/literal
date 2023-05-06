# frozen_string_literal: true

class Literal::Something < Literal::Maybe
	def initialize(value)
		@value = value
		freeze
	end

	def empty? = false
	def inspect = "Something(#{@value.inspect})"

	def value_or(_fallback)
		@value
	end

	def map
		Something(yield @value)
	end

	def flatmap
		map(yield(@value)).value_or(Nothing)
	end

	def or_else(_alternative)
		self
	end
end
