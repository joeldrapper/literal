# frozen_string_literal: true

class Literal::Some < Literal::Maybe
	def initialize(value)
		@value = value
		freeze
	end

	attr_accessor :value

	def empty? = false
	def inspect = "Some(#{@value.inspect})"

	def value_or
		@value
	end

	def bind
		output = yield @value

		case output
		when Literal::Maybe
			output
		else
			raise Literal::TypeError,
				"Block passed to `Literal::Maybe#bind` must return a `#{Literal::Maybe.inspect}`."
		end
	end

	def map
		output = yield @value
		Literal::Some.new(output)
	end

	def maybe
		output = yield @value

		case output
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
