# frozen_string_literal: true

class Literal::NothingClass < Literal::Maybe
	def initialize
		freeze
	end

	def empty? = true
	def inspect = "Nothing"

	def value_or
		yield
	end

	def bind
		self
	end

	def map
		self
	end

	def maybe
		self
	end

	def filter
		self
	end
end
