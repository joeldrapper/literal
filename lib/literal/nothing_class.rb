# frozen_string_literal: true

# @note This class is not meant to be instantiated. You should use the `Literal::Nothing` instance.
class Literal::NothingClass < Literal::Maybe
	def initialize
		freeze
	end

	# @return [String]
	def inspect = "Literal::Nothing"

	# @return [true]
	def empty? = true

	# @return [true]
	def nothing? = true

	# @return [false]
	def something? = false

	def value_or = yield

	def fmap = self
	def map = self
	def bind = self
	def then = self
	def filter = self

	def ===(value)
		self == value
	end

	def deconstruct
		[]
	end

	def deconstruct_keys(_)
		{}
	end
end
