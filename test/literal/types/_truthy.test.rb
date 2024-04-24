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

test "== method" do
	assert _Truthy == _Truthy
	assert _Truthy.eql?(_Truthy)

	assert _Truthy != _Any
	assert _Truthy != nil
	assert _Truthy != Object.new
end
