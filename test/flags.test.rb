# frozen_string_literal: true

class Example < Literal::Flags
	define(
		enabled: 0,
		started: 1,
		ended: 2,
	)
end

test "to bit string" do
	flags = Example.new(started: true)

	expect(flags.to_bit_string) == "00000010"
end

test "from bit string" do
	flags = Example.from_bit_string("00000010")

	refute flags.enabled?
	assert flags.started?
	refute flags.ended?
end

test "getters and setters" do
	flags = Example.new(0)

	refute flags.enabled?

	flags.enabled = true

	assert flags.enabled?

	flags.enabled = false

	refute flags.enabled?
end

test "hash-like" do
	flags = Example.new(0)

	refute flags[:enabled]

	flags[:enabled] = true

	assert flags[:enabled]

	flags[:enabled] = false

	refute flags[:enabled]
end

test "to_h" do
	flags = Example.new(0)

	flags.enabled = true
	flags.started = true

	expect(flags.to_h) == {
		enabled: true,
		started: true,
		ended: false,
	}
end

test "[]" do
	flags = Example.new(enabled: true)

	assert flags.enabled?
	refute flags.started?
	refute flags.ended?
end

test "to_a (via Enumerable)" do
	flags = Example.new(enabled: true)

	expect(flags.map.to_a) == [
		[:enabled, true],
		[:started, false],
		[:ended, false],
	]
end

test "merge!" do
	flags = Example.new(enabled: true)
	flags.merge!({ started: true })

	assert flags.enabled?
	assert flags.started?
	refute flags.ended?
end

test "deconstruct" do
	flags = Example.new(enabled: true)
	expect(flags.deconstruct) == [true, false, false]
end

test "deconstruct_keys with no filter" do
	flags = Example.new(enabled: true)

	expect(flags.deconstruct_keys) == {
		enabled: true,
		started: false,
		ended: false,
	}
end

test "deconstruct_keys with filter" do
	flags = Example.new(enabled: true)

	expect(flags.deconstruct_keys([:enabled, :ended])) == {
		enabled: true,
		ended: false,
	}
end
