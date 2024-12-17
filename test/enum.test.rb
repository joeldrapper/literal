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

test do
	assert_equal([Color::Red], Color.where(hex: "#FF0000"))
	assert_equal(Color::Red, Color.find_by(hex: "#FF0000"))
	assert_raises(ArgumentError) { Color.find_by(lower_hex: "#ff0000") }
	assert_equal([Color::Red], Color.where(lower_hex: "#ff0000"))
	assert_equal(1, Color::Red.value)
	assert_equal("#FF0000", Color::Red.hex)
	assert_equal(true, Color::Red.red?)
	assert_equal(false, Color::Red.green?)
	assert_equal(true, Color.frozen?)
	assert_equal(true, Color::Red.frozen?)
	assert_equal(Color::Red, Color[1])
	assert_equal(Color::Red, Color.cast(1))
	assert_equal(Color::Red, Color.coerce(1))
	assert_equal(Color::Red, Color.coerce(Color::Red))
	assert_equal(Set[Color::Red, Color::Green, Color::Blue], Color.to_set)
	assert_equal({ Color::Red => 1, Color::Green => 2, Color::Blue => 3 }, Color.to_h)
	assert_equal([Color::Red, Color::Green, Color::Blue], Color.to_a) if RUBY_VERSION >= "3.2"
	assert_equal([1, 2, 3], Color.values) if RUBY_VERSION >= "3.2"
	assert_equal([Color::Blue, Color::Green, Color::Red], [3, 2, 1].map(&Color))
	assert_equal([Color::Red, Color::Green], [Color::Red, 2].map(&Color))

	assert_equal(Switch::On, Switch::Off.toggle)
	assert_equal(Switch::Off, Switch::On.toggle)
end

test "pattern matching" do
	match { Color::Red => Color }
	match { Color::Red => Color[1] }
	match { Color::Red => Color[hex: "#FF0000"] }
end
