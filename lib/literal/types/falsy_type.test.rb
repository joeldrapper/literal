# frozen_string_literal: true

include Literal::Types

test do
	assert FalsyType === false
	assert FalsyType === nil

	refute FalsyType === 0
	refute FalsyType === true
end
