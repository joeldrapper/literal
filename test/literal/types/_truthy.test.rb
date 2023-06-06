# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Truthy.inspect) == "_Truthy"
end

test "===" do
	assert _Truthy === 1
	assert _Truthy === true
	assert _Truthy === "false"

	refute _Truthy === false
	refute _Truthy === nil
end
