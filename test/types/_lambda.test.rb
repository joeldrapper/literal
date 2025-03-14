# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Lambda === -> {}
	assert _Lambda === -> (arg) { arg }
	assert _Lambda === lambda {}

	refute _Lambda === proc {}
end
