# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Falsy.inspect) == "_Falsy"
end

test "===" do
	assert _Falsy === false
	assert _Falsy === nil

	refute _Falsy === 1
	refute _Falsy === true
	refute _Falsy === "false"
end

test "== method" do
	assert _Falsy == _Falsy
	assert _Falsy.eql?(_Falsy)
	assert _Falsy != _Truthy
	assert _Falsy != nil
	assert _Falsy != Object.new
end
