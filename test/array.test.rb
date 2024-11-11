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

test "#& performs bitwise AND with another Literal::Array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(Integer).new(2, 3, 4)

	expect((array & other).to_a) == [2, 3]
end

test "#& performs bitwise AND with an Array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = [2, 3, 4]

	expect((array & other).to_a) == [2, 3]
end

test "#sort sorts the array" do
	array = Literal::Array(Integer).new(3, 2, 1)

	result = array.sort
	assert Literal::Array(Integer) === result
	expect(array.sort.to_a) == [1, 2, 3]
end

test "#push appends single value" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect((array.push(4)).to_a) == [1, 2, 3, 4]
end

test "#push appends multiple values" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect((array.push(4, 5)).to_a) == [1, 2, 3, 4, 5]
end

test "#push raises if any type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array.push("4") }.to_raise(Literal::TypeError)
	expect { array.push(4, "5") }.to_raise(Literal::TypeError)
end

test "#insert inserts single element at index offset" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect((array.insert(1, 4)).to_a) == [1, 4, 2, 3]
end

test "#insert inserts multiple elements at index offset" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect((array.insert(1, 4, 5, 6)).to_a) == [1, 4, 5, 6, 2, 3]
end

test "#insert raises if any type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array.insert(1, "4") }.to_raise(Literal::TypeError)
	expect { array.insert(1, 4, "5", 6) }.to_raise(Literal::TypeError)
end

test "#replace replaces with passed in array" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect((array.replace([4, 5, 6])).to_a) == [4, 5, 6]
end

test "#replace replaces with passed in Literal::Array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(Integer).new(4, 5, 6)

	expect((array.replace(other)).to_a) == [4, 5, 6]
end

test "#replace raises if type of any element in array is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array.replace([1, "4"]) }.to_raise(Literal::TypeError)
	expect { array.replace(Literal::Array(String).new("4", "5")) }.to_raise(Literal::TypeError)
end

test "#replace raises with non-array argument" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array.replace("not an array") }.to_raise(ArgumentError)
end
