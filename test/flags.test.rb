# frozen_string_literal: true

class Example < Literal::Flags8
	define(
		bold: 0,
		italic: 1,
		underlined: 2,
	)
end

test "with" do
	a = Example.new(italic: true, underlined: true)
	b = a.with(bold: true, underlined: false)

	refute a.bold?
	assert a.italic?
	assert a.underlined?

	assert b.bold?
	assert b.italic?
	refute b.underlined?
end

test "from_array" do
	flags = Example.from_array([false, false, false, false, false, false, false, true])

	assert flags.bold?
end

test "to bit string" do
	flags = Example.new(italic: true)
	expect(flags.to_bit_string) == "00000010"
end

test "from bit string" do
	flags = Example.from_bit_string("00000010")

	refute flags.bold?
	assert flags.italic?
	refute flags.underlined?
end

test "hash-like" do
	flags = Example.new(
		bold: true,
	)

	assert flags[:bold]
	refute flags[:italic]
	refute flags[:underlined]
end

test "#to_h" do
	flags = Example.new(
		bold: true,
		italic: true,
	)

	expect(flags.to_h) == {
		bold: true,
		italic: true,
		underlined: false,
	}
end

test "#map (via Enumerable)" do
	flags = Example.new(bold: true)

	expect(flags.map.to_a) == [
		[:bold, true],
		[:italic, false],
		[:underlined, false],
	]
end

test ".from_tokens" do
	flags = Example.from_tokens([:bold, :italic])

	assert flags.bold?
	assert flags.italic?
	refute flags.underlined?
end

test "#to_tokens" do
	flags = Example.new(bold: true, italic: true)
	expect(flags.to_tokens) == [:bold, :italic]
end

test "#to_a" do
	flags = Example.new(bold: true)
	expect(flags.to_a) == [false, false, false, false, false, false, false, true]
end

test "#deconstruct_keys with no filter" do
	flags = Example.new(bold: true)

	expect(flags.deconstruct_keys) == {
		bold: true,
		italic: false,
		underlined: false,
	}
end

test "#deconstruct_keys with filter" do
	flags = Example.new(bold: true)

	expect(flags.deconstruct_keys([:bold, :underlined])) == {
		bold: true,
		underlined: false,
	}
end
