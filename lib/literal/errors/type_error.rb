# frozen_string_literal: true

class Literal::TypeError < TypeError
	INDENT = "  "

	include Literal::Error

	def initialize(actual:, expected:, context:)
		context = context.call

		@actual = actual
		@expected = expected
		@context = context

		message = +"Type mismatch\n\n"

		context.compact.each_with_index do |line, index|
			message << (INDENT * index) << line << "\n"
		end

		indent = (INDENT * context.size)

		message << indent << "Expected: #{expected.inspect}\n"
		message << indent << "Actual (#{actual.class.name}): #{actual.inspect}\n"

		super(message.freeze)
	end

	def self.expected(value, to_be_a:)
		new(expected: to_be_a, actual: value)
	end

	def deconstruct_keys(keys)
		to_h.slice(*keys)
	end

	def to_h
		{
			message:,
			expected: @expected,
			actual: @actual,
			context: @context,
		}
	end
end
