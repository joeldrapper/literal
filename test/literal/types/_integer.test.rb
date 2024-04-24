# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Integer(1..2) === 1
	assert _Integer(1..2) === 2

	refute _Integer(1..2) === 0
	refute _Integer(1..2) === 3
	refute _Integer(1..2) === 1.0
end

test "== method" do
	assert _Integer(1..2) == _Integer(1..2)
	assert _Integer(1..2).eql?(_Integer(1..2))
	assert _Integer(1..10) != _Integer(1..2)
	assert _Integer(1..2) != _Integer(2..3)
	assert _Integer(1..2) != nil
	assert _Integer(1..2) != Object.new
end
