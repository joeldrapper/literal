# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Union(String, Integer) === "a"
	assert _Union(String, Integer) === 1

	refute _Union(String, Integer) === :a
	refute _Union(String, Integer) === 1.0
end

test "== method" do
	assert _Union(String, Integer) == _Union(String, Integer)
	assert _Union(String, Integer).eql?(_Union(String, Integer))
	assert _Union(String, Integer) != _Union(String, Float)
	assert _Union(String, Integer) != nil
	assert _Union(String, Integer) != Object.new
end
