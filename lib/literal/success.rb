# frozen_string_literal: true

class Literal::Success < Literal::Result
	# @return [String]
	def inspect = "Literal::Success(#{@value.inspect})"

	# @return [true]
	def success? = true

	# @return [false]
	def failure? = false

	# @return [Literal::Some]
	def success = Literal::Some.new(@value)

	# @return [Literal::NothingClass]
	def failure = Literal::Nothing

	def raise! = self
	def value_or = @value

	def map
		Literal::Success.new(yield @value)
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def bind
		yield @value
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def then
		output = yield @value
		if Literal::Result === output
			output
		else
			Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: Literal::Result)
			)
		end
	end

	# @return [Literal::Result]
	def maybe
		case (output = yield @value)
		when nil
			Literal::Failure.new(
				RuntimeError.new(
					"Nil value returned from block."
				)
			)
		else
			Literal::Success.new(output)
		end
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	# @return [Literal::Result]
	def filter
		if yield(@value)
			self
		else
			Literal::Failure.new(
				RuntimeError.new(
					"Filter condition not met."
				)
			)
		end
	end
end
