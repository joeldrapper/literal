# frozen_string_literal: true

let def whatever = Literal::Array(Integer).new([1, 2, 3])

describe "#<<" do
	test "with valid item" do
		expect((whatever << 4).value) == [1, 2, 3, 4]
	end

	test "with invalid item" do
		expect { whatever << "1" }.to_raise Literal::TypeError
	end
end
