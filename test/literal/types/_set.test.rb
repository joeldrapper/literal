# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Set(String) === Set.new(["a", "b", "c"])

	refute _Set(String) === Set.new(["a", "b", 1])
	refute _Set(String) === ["a", "b", "c"]
end

test "== method" do
	assert _Set(String) == _Set(String)
	assert _Set(String).eql?(_Set(String))
	assert _Set(String) != _Set(Integer)
	assert _Set(String) != _Array(String)
	assert _Set(String) != nil
	assert _Set(String) != Object.new
end
