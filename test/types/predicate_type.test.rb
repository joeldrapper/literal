# frozen_string_literal: true

include Literal::Types

test "success" do
	predicate = _Predicate("starts with 'H'") { it.start_with? "H" }

	assert predicate === "Hello"
	refute predicate === "World"
end
