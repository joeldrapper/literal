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

test "== method" do
	assert _Not(_Boolean) == _Not(_Boolean)
	assert _Not(_Boolean).eql?(_Not(_Boolean))
	assert _Not(_Boolean) != _Not(_Integer(0..1))
	assert _Not(_Boolean) != nil
	assert _Not(_Boolean) != Object.new
end
