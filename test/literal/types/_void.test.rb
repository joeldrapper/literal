# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Void === _Void
	assert _Void === 0
	assert _Void === "a"
	assert _Void === :a
	assert _Void === []
	assert _Void === {}
	assert _Void === Object.new
	assert _Void === Class.new
	assert _Void === nil
end

test "== method" do
	assert _Void == _Void
	assert _Void.eql?(_Void)
	refute _Void == _Array(String)
	refute _Void == nil
	refute _Void == Object.new
end
