# frozen_string_literal: true

class Literal::Nothing < Literal::Maybe
	def initialize
		freeze
	end

	def empty? = true
	def inspect = "Nothing"

	def value_or(fallback)
		fallback
	end

	def map
		self
	end

	def flat_map
		raise ArgumentError, "No block given" unless block_given?
		self
	end

	def or_else(alternative)
		Something(alternative)
	end
end
