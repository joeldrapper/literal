# frozen_string_literal: true

test "#initialize" do
	expect {
		Literal::Array(String).new(1, 2, 3)
	}.to_raise(Literal::TypeError)
end

test "#to_a" do
	array = Literal::Array(Integer).new(1, 2, 3)
	expect(array.to_a) == [1, 2, 3]

	internal_array = array.__value__
	refute internal_array.equal?(array.to_a)
end

test "#map maps each item correctly" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(
		array.map(String, &:to_s).to_a
	) == ["1", "2", "3"]
end

test "#map raises if the type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect {
		array.map(Integer, &:to_s)
	}.to_raise(Literal::TypeError)
end

test "#[]" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array[0]) == 1
	expect(array[1]) == 2
	expect(array[2]) == 3
	expect(array[3]) == nil
end

test "#[]= raises if the type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array[0] = "1" }.to_raise(Literal::TypeError)
end

test "#[]= works as expected" do
	array = Literal::Array(Integer).new(1, 2, 3)

	array[0] = 5
	array[3] = 6

	expect(array[0]) == 5
	expect(array[3]) == 6
end

test "#<< inserts a new item" do
	array = Literal::Array(Integer).new(1, 2, 3)

	array << 4

	expect(array.to_a) == [1, 2, 3, 4]
end

test "#<< raises if the type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array << "4" }.to_raise(Literal::TypeError)
end
