# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Interface(:to_a) === { a: 1 }

	refute _Interface(:to_a) === ""
end
