# frozen_string_literal: true

include Literal::Types

test "===" do
	refute _Never === _Never
	refute _Never === 0
	refute _Never === "a"
	refute _Never === :a
	refute _Never === []
	refute _Never === {}
	refute _Never === Object.new
	refute _Never === Class.new
	refute _Never === nil
end

test "== method" do
	assert _Never == _Never
	assert _Never.eql?(_Never)
	refute _Never == _Array(String)
	refute _Never == nil
	refute _Never == Object.new
end
