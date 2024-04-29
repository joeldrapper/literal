# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Tuple(String, Integer) === ["a", 1]

	refute _Tuple(String, Integer) === ["a", "b"]
	refute _Tuple(String, Integer) === ["a", 1, "b"]
end

test "== method" do
	assert _Tuple(String, Integer) == _Tuple(String, Integer)
	assert _Tuple(String, Integer).eql?(_Tuple(String, Integer))
	assert _Tuple(String, Integer) != _Tuple(Integer, String)
	assert _Tuple(String, Integer) != nil
	assert _Tuple(String, Integer) != Object.new
end
