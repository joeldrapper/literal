# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Array(String) === ["a", "b", "c"]

	refute _Array(String) === ["a", "b", 1]
	refute _Array(String) === Set.new(["a", "b", "c"])
end
