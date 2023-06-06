# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Set(String) === Set.new(["a", "b", "c"])

	refute _Set(String) === Set.new(["a", "b", 1])
	refute _Set(String) === ["a", "b", "c"]
end
