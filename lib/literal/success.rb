# frozen_string_literal: true

class Literal::Success < Literal::Result
	def success? = true
	def failure? = false

	def inspect = "Literal::Success(#{@value.inspect})"

	def success = Literal::Some.new(@value)
	def failure = Literal::Nothing

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

	def filter
		yield if @value
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
