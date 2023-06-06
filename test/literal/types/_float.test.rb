# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Float(0..1) === 0.0
	assert _Float(0..1) === 0.5
	assert _Float(0..1) === 1.0

	refute _Float(0..1) === -1.0
	refute _Float(0..1) === 1.1
end
