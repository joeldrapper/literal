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
			Literal::Success.new(value)
		when StandardError
			Literal::Failure.new(value)
		else
			Literal::Failure.new(
				Literal::TypeError.new(
					"Expected `#{value.inspect}` to be a `#{@type.inspect}`."
				)
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
		output = yield
		if @type === output
			Literal::Success.new(output)
		else
			Literal::Failure.new(
				Literal::TypeError.new(
					"Expected `#{output.inspect}` to be a `#{@type.inspect}`."
				)
			)
		end
	rescue StandardError => e
		Literal::Failure.new(e)
	end
end
