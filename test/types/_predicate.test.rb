# frozen_string_literal: true

include Literal::Types

test "===" do
	predicate = _Predicate("starts with 'H'") { |it| it.start_with? "H" }

	assert predicate === "Hello"
	refute predicate === "World"
end

test "predicates are subtypes of themselves" do
	predicate = _Predicate("even") { |it| it.even? }

	assert_subtype predicate, predicate
end
