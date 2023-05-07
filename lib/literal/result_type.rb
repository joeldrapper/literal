# frozen_string_literal: true

class Literal::ResultType
	def initialize(type)
		@type = type
	end

	def inspect
		"Result(#{@type.inspect})"
	end

	def new(value)
		case value
		when @type
			Literal::Success.new(value)
		else
			Literal::Failure.new(value)
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
