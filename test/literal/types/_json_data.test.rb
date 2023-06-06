# frozen_string_literal: true

include Literal::Types

test "===" do
	examples = [
		"", "hello",
		0, 1, -1,
		0.0, 1.0, -1.0,
		true, false,
		nil,
		{}, { "a" => 1, "b" => 2 },
		[], [1, 2, 3]
	]

	examples.each { |e| assert _JSONData === e }

	refute _JSONData === :Hi
	refute _JSONData === Object.new
	refute _JSONData === { 1 => 2 }
end
