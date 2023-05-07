# frozen_string_literal: true

class Literal::Failure < Literal::Result::Option
	def initialize(value)
		@value = case value
		when StandardError
			value
		else
			Literal::TypeError.new(
				"Expected #{value.inspect} to be a `StandardError`."
			)
		end

		freeze
	end

	def failure? = true
	def success? = false

	def inspect
		"Literal::Failure(#{@value.inspect})"
	end

	def raise!
		raise @value
	end
end
