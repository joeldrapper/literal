# frozen_string_literal: true

test "Array" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array[0]) == 1
	expect(array.map(String, &:to_s)[0]) == "1"

	expect { array << "1" }.to_raise
	expect { array << 1 }.not_to_raise

	assert Literal::Array(Integer) === array
	refute Literal::Array(String) === array
end
