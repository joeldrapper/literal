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

	# @return [Literal::Nothing]
	def filter = self

	# @return [Literal::Nothing]
	def map(type = nil) = self

	# @return [Literal::Nothing]
	def then(type = nil) = self

	# @return [Literal::Nothing]
	def fmap = self

	# @return [Literal::Nothing]
	def bind = self

	def ===(value)
		self == value
	end

	def deconstruct
		[]
	end

	def deconstruct_keys(_)
		{}
	end

	def <=>(other)
		return unless Literal::NothingClass === other

		0
	end

	def eql?(other)
		Literal::NothingClass === other
	end
end
