# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Union(String, Integer) === "a"
	assert _Union(String, Integer) === 1

	refute _Union(String, Integer) === :a
	refute _Union(String, Integer) === 1.0
end
