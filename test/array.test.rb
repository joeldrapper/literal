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

test "#map! maps each item correctly" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.map!(&:succ).to_a) == [2, 3, 4]
end

test "map! raises if the type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect { array.map!(&:to_s) }.to_raise(Literal::TypeError)
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

test "#== compares the Literal::Arrays" do
		array = Literal::Array(Integer).new(1, 2, 3)
		other = Literal::Array(Integer).new(1, 2, 3)

		expect(array == other) == true
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

test "#- removes elements from another Literal::Array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(Integer).new(1)

	result = array - other
	expect(result.to_a) == [2, 3]
end

test "#- removes elements from an array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = [1]

	result = array - other
	expect(result.to_a) == [2, 3]
end

test "#<=> works as expected" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array <=> [1, 2, 4]) == -1
	expect(array <=> [1, 2, 2]) == 1
	expect(array <=> [1, 2, 3, 4]) == -1
	expect(array <=> [1, 2]) == 1
	expect(array <=> [1, 2, 3]) == 0
end

test "#<=> works with another Literal::Array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(Integer).new(1, 2, 4)

	expect(array <=> other) == -1
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

test "#assoc returns the correct element" do
	array = Literal::Array(Array).new([1, 2], [3, 4])

	expect(array.assoc(1)) == [1, 2]
	expect(array.assoc(3)) == [3, 4]
end

test "#combination yields to the block" do
	array = Literal::Array(Integer).new(1, 2, 3)
	results = []

	array.combination(2) { |x| results << x }
	expect(results) == [[1, 2], [1, 3], [2, 3]]
end

test "#combination returns self" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.combination(0) { nil }) == array
end

test "#compact returns a new Literal::Array" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.compact.to_a) == [1, 2, 3]
	assert Literal::Array(Integer) === array.compact
end

test "#compact! returns nil" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.compact!) == nil
end

test "#delete deletes the element" do
	array = Literal::Array(Integer).new(1, 2, 3)

	array.delete(2)
	expect(array.to_a) == [1, 3]
end

test "#delete returns the deleted element" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.delete(2)) == 2
end

test "#delete_at deletes the element at the index" do
	array = Literal::Array(Integer).new(1, 2, 3)

	array.delete_at(1)
	expect(array.to_a) == [1, 3]
end

test "#delete_at returns the deleted element" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.delete_at(1)) == 2
end

test "#delete_if deletes elements that match the block" do
	array = Literal::Array(Integer).new(1, 2, 3)

	array.delete_if { |i| i < 2 }
	expect(array.to_a) == [2, 3]
end

test "#drop returns a new array with the first n elements removed" do
		array = Literal::Array(Integer).new(1, 2, 3)
		dropped = array.drop(1)

		expect(dropped.to_a) == [2, 3]
		expect(dropped) == Literal::Array(Integer).new(2, 3)

		dropped = array.drop(2)
		expect(dropped.to_a) == [3]
		expect(dropped) == Literal::Array(Integer).new(3)
end

test "#drop_while returns a new array with the first n elements removed" do
		array = Literal::Array(Integer).new(1, 2, 3)
		dropped = array.drop_while { |i| i < 2 }

		expect(dropped.to_a) == [2, 3]
		expect(dropped) == Literal::Array(Integer).new(2, 3)
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

test "#intersection returns an array of the intersection of two arrays" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(Integer).new(2, 3, 4)

	intersection = array.intersection(other, [2])

	assert Literal::Array(Integer) === intersection
	expect(intersection.to_a) == [2]
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

test "#values_at returns the values at the given indexes" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.values_at(0).to_a) == [1]
	expect(array.values_at(1).to_a) == [2]
	expect(array.values_at(2).to_a) == [3]
	expect(array.values_at(1..2).to_a) == [2, 3]

	expect { array.values_at(3) }.to_raise(IndexError)
	expect { array.values_at(-4) }.to_raise(IndexError)
	expect { array.values_at(-4..2) }.to_raise(IndexError)
	expect { array.values_at(1..3) }.to_raise(IndexError)

	nilable_array = Literal::Array(_Nilable(Integer)).new(1, 2, 3)

	expect(nilable_array.values_at(-4).to_a) == [nil]
	expect(nilable_array.values_at(3).to_a) == [nil]
end

test "#uniq! removes duplicates" do
	array = Literal::Array(Integer).new(1, 2, 3, 2, 1)

	expect((array.uniq!).to_a) == [1, 2, 3]
end

test "#uniq! returns nil if no duplicates" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.uniq!) == nil
end

test "#uniq returns a new array with duplicates removed" do
	array = Literal::Array(Integer).new(1, 2, 2, 3, 3, 3)

	expect((array.uniq).to_a) == [1, 2, 3]
	expect(array.uniq) == Literal::Array(Integer).new(1, 2, 3)
end

test "#| returns a union of two Literal::Arrays" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(Integer).new(2, 3, 4)

	union = array | other

	assert Literal::Array(Integer) === union
	expect(union.to_a) == [1, 2, 3, 4]
end

test "#| returns a union of a Literal::Array and an Array" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = [2, 3, 4]

	union = array | other

	assert Literal::Array(Integer) === union
	expect(union.to_a) == [1, 2, 3, 4]
end

test "#| raises if the type is wrong" do
	array = Literal::Array(Integer).new(1, 2, 3)
	other = Literal::Array(String).new("2", "3")
	other_primitive = ["2", "3"]

	expect { array | other }.to_raise(Literal::TypeError)
	expect { array | other_primitive }.to_raise(Literal::TypeError)
end

test "#sum" do
	expect(Literal::Array(Integer).new(1, 2, 3).sum) == 6
	expect(Literal::Array(String).new("1", "2", "3").sum(&:to_i)) == 6
end

test "#select returns a new array with elements that match the block" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect((array.select { |i| i > 1 }).to_a) == [2, 3]
end

test "#select! removes elements that do not match the block" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect((array.select! { |i| i > 1 }).to_a) == [2, 3]
end

test "#select! returns [] if no elements match the block" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.select! { |i| i > 4 }) == []
end

test "#narrow" do
	array = Literal::Array(Numeric).new(1, 2, 3)

	result = array.narrow(Integer)
	assert Literal::Array(Integer) === result
end

test "#narrow with same type" do
	array = Literal::Array(Numeric).new(1, 2, 3)

	assert Literal::Array(Numeric) === array
end

test "#narrow with wrong value" do
	array = Literal::Array(Numeric).new(1, 2, 3.456)

	expect {
		array.narrow(Integer)
	}.to_raise(Literal::TypeError)
end

test "#narrow with wrong type" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect {
		array.narrow(Numeric)
	}.to_raise(ArgumentError)
end

test "#flatten! flattens the array" do
	array = Literal::Array(Array).new([1, 2], [3, 4])

	expect((array.flatten!).to_a) == [1, 2, 3, 4]
end

test "#flatten! returns nil if no nested arrays" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.flatten!) == nil
end

test "#flatten flattens the array" do
	array = Literal::Array(Array).new([1, 2], [3, 4])

	expect(array.flatten.to_a) == [1, 2, 3, 4]
end

test "#flatten with level flattens the array" do
	array = Literal::Array(Array).new([1, 2], [3, 4])

	expect(array.flatten(1).to_a) == [1, 2, 3, 4]
end

test "#fetch" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.fetch(0)) == 1
	expect(array.fetch(1)) == 2
	expect(array.fetch(2)) == 3
	expect { array.fetch(3) }.to_raise(IndexError)
end

test "#inspect returns a string representation of the array" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.inspect) == "[1, 2, 3]"
end

test "#to_s returns a string representation of the array" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.to_s) == "[1, 2, 3]"
end

test "#fetch returns default value if element is missing at index" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.fetch(4, :missing)) == :missing
end

test "#fetch returns value of block if element is missing at index" do
	array = Literal::Array(Integer).new(1, 2, 3)

	expect(array.fetch(4) { |index| index * 2 }) == 8
end
