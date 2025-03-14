# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Frozen(Array) === [].freeze
	assert _Frozen(String) === "immutable"

	refute _Frozen(Array) === []
	refute _Frozen(String) === +"mutable"
	refute _Frozen(Array) === nil
end

test "hierarchy" do
	assert_subtype _Constraint(Array, frozen?: true), _Frozen(Enumerable)
end
