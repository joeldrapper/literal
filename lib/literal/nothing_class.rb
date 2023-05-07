# frozen_string_literal: true

class Literal::NothingClass < Literal::Maybe
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

	def or(alternative)
		if alternative.nil?
			raise Literal::TypeError, "Alternative cannot be nil."
		end

		if alternative.nil?
			self
		else
			Literal::Some.new(alternative)
		end
	end
end
