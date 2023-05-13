# frozen_string_literal: true

class Literal::Some < Literal::Maybe
	def initialize(value)
		@value = value
		freeze
	end

	attr_accessor :value

	def empty? = false
	def nothing? = false
	def something? = true

	def inspect = "Some(#{@value.inspect})"

	def value_or = @value

	def map
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

	def maybe
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
end
