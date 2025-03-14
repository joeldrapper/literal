# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Integer(18..) === 18
	assert _Integer(18..) === 19

	refute _Integer(18..) === 17
	refute _Integer(18..) === 18.5
	refute _Integer(18..) === "string"
	refute _Integer(18..) === nil
end
