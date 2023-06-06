# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_Lambda.inspect) == "_Lambda"
end

test "===" do
	assert _Lambda === -> {}

	refute _Lambda === proc {}
end
