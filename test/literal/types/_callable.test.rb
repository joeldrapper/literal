# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Callable.inspect) == "_Callable"
end

test "===" do
	assert _Callable === -> {}

	refute _Callable === 1
end

test "== method" do
	assert _Callable == _Callable
	assert _Callable.eql?(_Callable)
	assert _Callable != _Array(String)
	assert _Callable != nil
	assert _Callable != Object.new
end

