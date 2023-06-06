# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Tuple(String, Integer) === ["a", 1]

	refute _Tuple(String, Integer) === ["a", "b"]
	refute _Tuple(String, Integer) === ["a", 1, "b"]
end
