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

	def value_or_raise! = @value

	def value_or
		if block_given?
			@value
		else
			raise Literal::ArgumentError, "Expected block."
		end
	end

	def fmap
		Literal::Success.new(yield @value)
	end

	def map(type = Literal::Null)
		output = yield @value

		if Literal::Null == type
			Literal::Success.new(output)
		elsif type === output
			Literal::Success.new(output)
		else
			Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: type)
			)
		end
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def bind
		yield @value
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def then(type = Literal::Null)
		output = yield @value

		if Literal::Null == type
			if Literal::Result === output
				output
			else
				Literal::Failure.new(
					Literal::TypeError.expected(output, to_be_a: Literal::Result)
				)
			end
		elsif Literal::Result(type) === output
			output
		else
			Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: Literal::Result(type))
			)
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

	def deconstruct
		if @value.respond_to?(:deconstruct)
			@value.deconstruct
		else
			[@value]
		end
	end

	def deconstruct_keys(keys)
		if @value.respond_to?(:deconstruct_keys)
			@value.deconstruct_keys(keys)
		else
			{ value: @value }
		end
	end

	def lift(*, &block)
		if block
			Literal::Lift.new(*, &block).with_success(@value)
		else
			self
		end
	end

	def lift!(*, &block)
		if block
			Literal::Lift.new(*, &block).with_success!(@value)
		else
			self
		end
	end
end
