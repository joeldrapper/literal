# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Hash(String, Integer) === { "a" => 1, "b" => 2, "c" => 3 }

	refute _Hash(String, Integer) === { "a" => 1, "b" => 2, 3 => "c" }
end
