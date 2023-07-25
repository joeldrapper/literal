# frozen_string_literal: true

# @api private
class Literal::ResultType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Literal::Result(#{@type.inspect})"

	def new(value)
		case value
		when Literal::Success(@type), Literal::Failure
			value
		else
			Literal::Failure.new(
				Literal::TypeError.expected(value, to_be_a: self)
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
