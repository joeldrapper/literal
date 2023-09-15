# frozen_string_literal: true

# @api private
class Literal::ResultType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Literal::Result(#{@type.inspect})"

	def new(value)
		case value
		when @type
			return Literal::Success.new(value)
		when Literal::Failure
			return value
		when Literal::Success
			if @type === value.value
				return value
			end
		end

		Literal::Failure.new(
			Literal::TypeError.expected(value,
				to_be_a: Literal::Union.new(@type, Exception)
			)
		)
	end

	def success(value)
		if @type === value
			Literal::Success.new(value)
		else
			Literal::Failure.new(
				Literal::TypeError.expected(value, to_be_a: @type)
			)
		end
	end

	def failure(value)
		if Exception === value
			Literal::Failure.new(value)
		else
			Literal::Failure.new(
				Literal::TypeError.expected(value, to_be_a: Exception)
			)
		end
	end

	def ===(value)
		case value
		when Literal::Success
			@type === value.value
		when Literal::Failure
			true
		else
			false
		end
	end

	def try
		new(yield(self))
	rescue StandardError => e
		Literal::Failure.new(e)
	end
end
