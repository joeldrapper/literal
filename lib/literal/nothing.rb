# frozen_string_literal: true

class Literal::Nothing < Literal::Optional::Option
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
		self
	end

	def or_else(alternative)
		if alternative.nil?
			self
		else
			Some(alternative)
		end
	end
end
