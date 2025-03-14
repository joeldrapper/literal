# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Enumerable(String) === ["a", "b", "c"]
	assert _Enumerable(Integer) === Set[1, 2, 3]

	refute _Enumerable(String) === [1, "a", :symbol]
end

test "hierarchy" do
	assert_subtype _Enumerable(Array), _Enumerable(Enumerable)
	assert_subtype _Enumerable(Set), _Enumerable(Enumerable)

	refute_subtype _Enumerable(String), _Enumerable(Enumerable)
end
