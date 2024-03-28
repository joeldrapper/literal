# frozen_string_literal: true

include Literal::Monads

def nothing = Literal::Nothing

test "#inspect" do
	expect(nothing.inspect) == "Literal::Nothing"
end

test "#empty?" do
	expect(nothing).to_be :empty?
end

test "#nothing?" do
	expect(nothing).to_be :nothing?
end

test "#something?" do
	expect(nothing).not_to_be :something?
end

test "#value_or" do
	expect(nothing.value_or { 42 }) == 42
end

test "#fmap" do
	expect(nothing.fmap { |value| value * 2 }) == nothing
end

test "#map" do
	expect(nothing.map { |value| value * 2 }) == nothing
end

test "#bind" do
	expect(nothing.bind { |value| value * 2 }) == nothing
end

test "#then" do
	expect(nothing.then { |value| value * 2 }) == nothing
end

test "#filter" do
	expect(nothing.filter(&:even?)) == nothing
end

test "#===" do
	assert Literal::Nothing === nothing
	refute Literal::Nothing === Literal::Some(Integer).new(1)
end

test "#deconstruct" do
	expect(nothing.deconstruct) == []
end

test "#deconstruct_keys" do
	expect(nothing.deconstruct_keys(nil)) == {}
end

test "#eql?" do
	assert nothing.eql?(nothing)
	refute nothing.eql?(Literal::Some(Integer).new(1))
end

test "#==" do
	assert nothing == Literal::Nothing
	refute nothing == Literal::Some(Integer).new(1)
end

test "#!=" do
	assert nothing != Literal::Some(Integer).new(1)
	refute nothing != Literal::Nothing
end
