# frozen_string_literal: true

class Literal::Some < Literal::Maybe
	def initialize(value)
		@value = value
		freeze
	end

	attr_accessor :value

	# @return [String]
	def inspect = "Literal::Some(#{@value.inspect})"

	# @return [false]
	def empty? = false

	# @return [false]
	def nothing? = false

	# @return [true]
	def something? = true

	def value_or
		if block_given?
			@value
		else
			raise Literal::ArgumentError "no block given"
		end
	end

	def fmap
		Literal::Some.new(
			yield @value
		)
	end

	def then
		output = yield @value

		if Literal::Maybe === output
			output
		else
			raise Literal::TypeError.expected(output, to_be_a: Literal::Maybe)
		end
	end

	def map
		case (output = yield @value)
		when nil
			Literal::Nothing
		else
			Literal::Some.new(output)
		end
	end

	def filter
		yield @value ? self : Literal::Nothing
	end

	def deconstruct
		[@value]
	end

	def deconstruct_keys(_)
		{ value: @value }
	end
end
