# frozen_string_literal: true

include Literal::Types

test "===" do
	recursive = _Hash(
		String,
		_Deferred { recursive }
	)

	assert recursive === {
		"a" => {
			"b" => {
				"c" => {
					"d" => {
						"e" => {
							"f" => {
								"g" => {},
							},
						},
					},
				},
			},
		},
	}

	refute recursive === {
		"a" => {
			"b" => { 1 => {} },
		},
	}
end

test "hirearchy" do
	assert_subtype Integer, _Deferred { Numeric }
	assert_subtype _Deferred { Integer }, _Deferred { Numeric }
end
