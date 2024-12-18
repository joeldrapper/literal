# frozen_string_literal: true

extend Literal::Types

class Color < Literal::Enum(Integer)
	prop :hex, String

	index :hex, String

	index :lower_hex, String, unique: false do |color|
		color.hex.downcase
	end

	Red = new(1, hex: "#FF0000")
	Green = new(2, hex: "#00FF00")
	Blue = new(3, hex: "#0000FF")

	__after_defined__ if RUBY_ENGINE == "truffleruby"
end

class Switch < Literal::Enum(_Boolean)
	On = new(true) do
		def toggle = Off
	end

	Off = new(false) do
		def toggle = On
	end

	__after_defined__ if RUBY_ENGINE == "truffleruby"
end

class SymbolTypedEnum < Literal::Enum(Symbol)
	A = new(:B)
	B = new(:A)
end

test ".coerce from value" do
	assert_equal Color.coerce(1), Color::Red
end

test ".coerce from enum" do
	assert_equal Color.coerce(Color::Red), Color::Red
end

test ".coerce from symbol" do
	assert_equal Color.coerce(:Red), Color::Red
end

test ".coerce with invalid symbol returns nil" do
	assert_equal Color.coerce(:Invalid), nil
end

test ".[] looks up the key by value" do
	assert_equal Color[1], Color::Red
end

test ".[] returns nil if the member can't be found" do
	assert_equal Color[10], nil
end

test ".cast looks up the key by value" do
	assert_equal Color.cast(1), Color::Red
end

test ".cast returns nil if the member can't be found" do
	assert_equal Color.cast(10), nil
end

test ".cast goes with the value when there are conflicts with the keys" do
	assert_equal SymbolTypedEnum.coerce(:A), SymbolTypedEnum::B
end

test ".to_set" do
	assert_equal Color.to_set, Set[
		Color::Red,
		Color::Green,
		Color::Blue
	]
end

test ".to_h without block" do
	assert_equal Color.to_h, {
		Color::Red => 1,
		Color::Green => 2,
		Color::Blue => 3,
	}
end

test ".to_proc coerces" do
	assert_equal [1, :Green, Color::Blue].map(&Color), [
		Color::Red,
		Color::Green,
		Color::Blue,
	]
end

test "#where" do
	assert_equal [Color::Red], Color.where(hex: "#FF0000")
end

test "#find_by" do
	assert_equal Color::Red, Color.find_by(hex: "#FF0000")
end

test "#find_by raises when used with a non-unique index" do
	error = assert_raises(ArgumentError) { Color.find_by(lower_hex: "#ff0000") }
	assert_equal error.message, "You can only use `find_by` on unique indexes."
end

test "#value returns the value" do
	assert_equal Color::Red.value, 1
end

test "reading property readers" do
	assert_equal Color::Red.hex, "#FF0000"
end

test "generated predicates" do
	assert_equal Color::Red.red?, true
	assert_equal Color::Red.green?, false
	assert_equal Color::Red.blue?, false
end

test "members are frozen" do
	assert Color::Red.frozen?
end

test "classes are frozen" do
	assert Color.frozen?
end

test "singleton methods" do
	assert_equal Switch::Off.toggle, Switch::On
	assert_equal Switch::On.toggle, Switch::Off
end

test do
	assert_equal([Color::Blue, Color::Green, Color::Red], [3, 2, 1].map(&Color))
	assert_equal([Color::Red, Color::Green], [Color::Red, 2].map(&Color))
end

test "pattern matching" do
	match { Color::Red => Color }
	match { Color::Red => Color[1] }
	match { Color::Red => Color[hex: "#FF0000"] }
end
