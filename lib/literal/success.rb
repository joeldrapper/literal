# frozen_string_literal: true

class Literal::Success < Literal::Result
	# @return [String]
	def inspect = "Literal::Success(#{@value.inspect})"

	# @return [true]
	def success? = true

	# @return [false]
	def failure? = false

	# @return [Literal::Some]
	def success
		if block_given?
			yield(@value)
			self
		else
			Literal::Some.new(@value)
		end
	end

	# @return [Literal::NothingClass]
	def failure(error)
		block_given? ? self : Literal::Nothing
	end

	def raise! = self

	def value_or_raise! = @value

	def value_or
		if block_given?
			@value
		else
			raise Literal::ArgumentError, "Expected block."
		end
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

	def map(type)
		output = yield(@value)

		if type === output
			Literal::Success.new(output)
		else
			Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: type)
			)
		end
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def then(type)
		output = yield(@value)

		if Literal::Result(type) === output
			output
		else
			Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: Literal::Result(type))
			)
		end
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def fmap
		Literal::Success.new(yield @value)
	end

	def bind
		yield @value
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def deconstruct_keys(keys)
		if @value.respond_to?(:deconstruct_keys)
			@value.deconstruct_keys(keys)
		else
			{ value: @value }
		end
	end

	def lift(*, &block)
		block ? Literal::Lift.new(*, &block).with_success(@value) : self
	end

	def lift!(*, &block)
		block ? Literal::Lift.new(*, &block).with_success!(@value) : self
	end

	def map_failure(value_type = Exception) = self
	def then_on_failure(result_type) = self
end
