# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Class(StandardError) === StandardError
	assert _Class(StandardError) === RuntimeError

	refute _Class(StandardError) === Exception
	refute _Class(StandardError) === Object
	refute _Class(StandardError) === Class
end
