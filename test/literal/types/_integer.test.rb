# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Integer(1..2) === 1
	assert _Integer(1..2) === 2

	refute _Integer(1..2) === 0
	refute _Integer(1..2) === 3
	refute _Integer(1..2) === 1.0
end
