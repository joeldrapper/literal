# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Lambda.inspect) == "_Lambda"
end

test "===" do
	assert _Lambda === -> {}

	refute _Lambda === proc {}
end

test "== method" do
	assert _Lambda == _Lambda
	assert _Lambda.eql?(_Lambda)
	refute _Lambda == nil
	refute _Lambda == Object.new
end
