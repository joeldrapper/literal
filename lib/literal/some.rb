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
			raise Literal::ArgumentError, "no block given"
		end
	end

	# @return [Literal::Maybe]
	def filter
		yield(@value) ? self : Literal::Nothing
	end

	# @return [Literal::Maybe]
	def map(type = Literal::Null)
		output = yield(@value)

		if Literal::Null == type
			if nil == output
				Literal::Nothing
			else
				Literal::Some.new(output)
			end
		elsif type === output
			Literal::Some.new(output)
		else
			raise Literal::TypeError.expected(output, to_be_a: type)
		end
	end

	# @return [Literal::Maybe]
	def then(type = Literal::Null)
		output = yield(@value)

		if Literal::Null == type
			if Literal::Maybe === output
				output
			else
				raise Literal::TypeError.expected(output, to_be_a: Literal::Maybe)
			end
		elsif Literal::Maybe === output && type === output.value
			output
		else
			raise Literal::TypeError.expected(output, to_be_a: Literal::Maybe(type))
		end
	end

	# @return [Literal::Some]
	def fmap
		Literal::Some.new(
			yield(@value)
		)
	end

	def bind
		yield(@value)
	end

	def deconstruct
		[@value]
	end

	def deconstruct_keys(_)
		{ value: @value }
	end
end
