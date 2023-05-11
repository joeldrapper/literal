# frozen_string_literal: true

include Literal::Monads

describe "Either(Integer, String)" do
	let def either = Either(Integer, String)

	let def left = either.new(1)
	let def right = either.new("foo")

	test "===" do
		assert either === left
		assert either === right

		refute either === 1
		refute either === "foo"

		refute either === Literal::Left.new("foo")
		refute either === Literal::Right.new(1)
	end

	test "#left?" do
		expect(left).to_be :left?
		expect(right).not_to_be :left?
	end

	test "#right?" do
		expect(right).to_be :right?
		expect(left).not_to_be :right?
	end
end
