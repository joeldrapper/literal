# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Boolean.inspect) == "_Boolean"
end

test "===" do
	assert _Boolean === true
	assert _Boolean === false

	refute _Boolean === nil
	refute _Boolean === 0
	refute _Boolean === "true"
	refute _Boolean === "false"
	refute _Boolean === [true]
	refute _Boolean === [false]
	refute _Boolean === TrueClass
	refute _Boolean === FalseClass
end
