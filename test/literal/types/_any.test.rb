# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Any === 0
	assert _Any === "a"
	assert _Any === :a
	assert _Any === []
	assert _Any === {}
	assert _Any === Object.new
	assert _Any === Class.new

	refute _Any === nil
end
