# frozen_string_literal: true

class Literal::Some < Literal::Optional::Option
	def initialize(value)
		@value = value
		freeze
	end

	attr_accessor :value

	def empty? = false
	def inspect = "Some(#{@value.inspect})"

	def value_or(_fallback)
		@value
	end

	def map
		Some(yield @value)
	end

	def flat_map
		map(yield(@value)).value_or(Nothing)
	end

	def or_else(_alternative)
		self
	end
end
