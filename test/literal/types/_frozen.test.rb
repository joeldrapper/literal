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
