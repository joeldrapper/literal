# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Pattern(1, _Optional(2), 3) === [1, 2, 3]
	assert _Pattern(1, _Optional(2), 3) === [1, 3]
	assert _Pattern(1, _Optional(2), 3, _Rest(Integer), String) === [1, 3, 2, "Hello"]

	refute _Pattern(1, _Optional(2), 3) === [1, 3, 2]
end
