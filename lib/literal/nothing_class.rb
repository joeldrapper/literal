# frozen_string_literal: true

class Literal::NothingClass < Literal::Maybe
	def initialize
		freeze
	end

	def empty? = true
	def nothing? = true
	def something? = false

	def inspect = "Nothing"

	def value_or = yield

	def map = self
	def bind = self
	def then = self
	def maybe = self
	def filter = self

	def ===(value)
		self == value
	end
end
