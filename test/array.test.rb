# frozen_string_literal: true

include Literal::Types

test "===" do
	assert Literal::Array(_Boolean) === Literal::Array(true).new(true)
	assert Literal::Array(Object) === Literal::Array(Integer).new(1)
	assert Literal::Array(Numeric) === Literal::Array(Integer).new(1)
	assert Literal::Array(Numeric) === Literal::Array(Float).new(1.0)

	assert Literal::Array(
		Literal::Array(Numeric)
	) === Literal::Array(
		Literal::Array(Integer)
	).new(
		Literal::Array(Integer).new(1)
	)

	refute Literal::Array(true) === Literal::Array(_Boolean).new(true, false)
	refute Literal::Array(Integer) === Literal::Array(Numeric).new(1, 1.234)
end

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

test "#* with an integer multiplies the array" do
	array = Literal::Array(Integer).new(1, 2, 3)

	result = array * 2
	assert Literal::Array(Integer) === result
	expect(result.to_a) == [1, 2, 3, 1, 2, 3]
end

test "#* raises with a negative integer" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array * -1 }.to_raise(ArgumentError)
end

test "#* with a string joins the elements" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array * ",") == "1,2,3"
end

test "#+ adds another Literal::Array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(Integer).new(4, 5)

	result = array + other
	assert Literal::Array(Integer) === result
	expect(result.to_a) == [1, 2, 3, 4, 5]
end

test "#+ adds an array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = [4, 5]

	result = array + other
	assert Literal::Array(Integer) === result
	expect(result.to_a) == [1, 2, 3, 4, 5]
end

test "#+ raises if the type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(String).new("a", "b")
	other_primitive = ["a", "b"]

	expect { array + other }.to_raise(Literal::TypeError)
	expect { array + other_primitive }.to_raise(Literal::TypeError)
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
