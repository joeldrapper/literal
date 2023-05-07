# frozen_string_literal: true

class Literal::Some < Literal::Maybe
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
		Literal::Some.new(yield @value)
	end

	def flat_map(&block)
		map(&block).value_or(Nothing)
	end

	def or(_alternative)
		self
	end
end
