# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Array(String) === ["a", "b", "c"]
	refute _Array(String) === ["a", "b", 1]
	refute _Array(String) === Set.new(["a", "b", "c"])
end

test "== method" do
	assert _Array(String) == _Array(String)
	assert _Array(String).eql?(_Array(String))
	assert _Array(Integer) != _Array(String)
	assert _Array(String) != _Array(Symbol)
	assert _Array(String) != nil
	assert _Array(String) != Object.new
end
