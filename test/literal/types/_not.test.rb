# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Not(_Boolean).inspect) == "_Not(_Boolean)"
end

test "===" do
	assert _Not(_Boolean) === 1
	assert _Not(_Boolean) === "Hi"

	refute _Not(_Boolean) === true
	refute _Not(_Boolean) === false
end
