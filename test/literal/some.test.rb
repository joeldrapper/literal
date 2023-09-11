# frozen_string_literal: true

include Literal::Monads

describe "Some(Integer)" do
	let def some_int_monad = Some(Integer)

	let def some_val_1 = some_int_monad.new(1)
	let def some_val_2 = some_int_monad.new(2)

	test "===" do
		assert some_int_monad === some_val_1
		refute some_int_monad === 1
	end

	test "#empty?" do
		expect(some_val_1).not_to_be :empty?
	end

	test "#value" do
		expect(some_val_1.value) == 1
		expect(some_val_2.value) == 2
	end

	test "#nothing?" do
		expect(some_val_1).not_to_be :nothing?
	end

	test "#something?" do
		expect(some_val_1).to_be :something?
	end

	test "#value_or" do
		expect { some_val_1.value_or }.to_raise Literal::ArgumentError
		expect(some_val_1.value_or { 2 }) == 1
	end

	test "#fmap" do
		result = some_val_1.fmap { |value| value * 2 }
		expect(result.value) == 2
		assert some_int_monad === result
	end

	test "#then" do
		result = some_val_1.then { |value| Some(Integer).new(value * 2) }
		expect(result.value) == 2
		expect { some_val_1.then { |value| value * 2 } }.to_raise Literal::TypeError
	end

	test "#map" do
		result = some_val_1.map { |value| value * 2 }
		expect(result.value) == 2
		assert some_val_1.map { nil } === Literal::Nothing
	end

	test "#filter" do
		expect(some_val_1.filter(&:even?)) == Literal::Nothing
		expect(some_val_1.filter(&:odd?)) == some_val_1
	end

	test "#deconstruct" do
		expect(some_val_1.deconstruct) == [1]
	end

	test "#deconstruct_keys" do
		expect(some_val_1.deconstruct_keys(nil)) == { value: 1 }
	end
end
