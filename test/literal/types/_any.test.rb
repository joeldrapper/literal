# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Any === 0
	assert _Any === "a"
	assert _Any === :a
	assert _Any === []
	assert _Any === {}
	assert _Any === Object.new
	assert _Any === Class.new

	refute _Any === nil
end

test "== method" do
	assert _Any == _Any
	assert _Any.eql?(_Any)
	assert _Any != _Array(String)
	assert _Any != nil
	assert _Any != Object.new
end
