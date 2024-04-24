# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Frozen(String).inspect) == "_Frozen(String)"
end

test "===" do
	assert _Frozen(String) === "Hi"

	refute _Frozen(String) === +"Hi"
	refute _Frozen(Integer) === "Hi"
end

test "== method" do
	assert _Frozen(String) == _Frozen(String)
	assert _Frozen(String).eql?(_Frozen(String))
	assert _Frozen(String) != _Frozen(Integer)
	assert _Frozen(String) != _Any
	assert _Frozen(String) != nil
	assert _Frozen(String) != Object.new
end
