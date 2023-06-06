# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Callable.inspect) == "_Callable"
end

test "===" do
	assert _Callable === -> {}

	refute _Callable === 1
end
