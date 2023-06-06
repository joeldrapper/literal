# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Enumerable(String) === ["a", "b", "c"]
	assert _Enumerable(String) === Set.new(["a", "b", "c"])

	refute _Enumerable(String) === ["a", "b", 1]
	refute _Enumerable(String) === Set.new(["a", "b", 1])
end
