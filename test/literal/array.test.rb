# frozen_string_literal: true

let def whatever = Literal::Array(Integer).new([1, 2, 3])

describe "#<<" do
	test "with valid item" do
		whatever << 4
		expect(whatever) == [1, 2, 3, 4]
	end

	test "with invalid item" do
		expect { whatever << "1" }.to_raise Literal::TypeError
	end
end

describe "dup" do
	test do
		array = Literal::Array(Integer).new([1, 2, 3])
		duplicate = array.dup

		array << 4

		expect(duplicate) == [1, 2, 3]
	end
end

describe "#+" do
	test do
		a = Literal::Array(Integer).new([1, 2, 3])
		b = [4, 5, 6]

		both = a + b

		expect(both) == [1, 2, 3, 4, 5, 6]
		expect(both).to_be_a Literal::Array
	end
end

describe "#safe_map" do
	test do
		array = Literal::Array(Integer).new([1, 2, 3])
		array.safe_map!(String) { |number| number.to_s }

		expect(array) == ["1", "2", "3"]

		assert(Literal::Array(String) === array)
	end
end
