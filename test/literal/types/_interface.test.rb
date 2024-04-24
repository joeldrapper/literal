# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Interface(:to_a) === { a: 1 }

	refute _Interface(:to_a) === ""
end

test "== method" do
	assert _Interface(:to_a) == _Interface(:to_a)
	assert _Interface(:to_a).eql?(_Interface(:to_a))
	assert _Interface(:to_a) != _Interface(:to_s)
	assert _Interface(:to_a) != nil
	assert _Interface(:to_a) != Object.new
end
