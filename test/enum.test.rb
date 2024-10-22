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
	expect(Color::Red.name) =~ /Color::Red\z/
	expect(Color.where(hex: "#FF0000")) == [Color::Red]
	expect(Color.find_by(hex: "#FF0000")) == Color::Red
	expect { Color.find_by(lower_hex: "#ff0000") }.to_raise(ArgumentError)
	expect(Color.where(lower_hex: "#ff0000")) == [Color::Red]
	expect(Color::Red.value) == 1
	expect(Color::Red.hex) == "#FF0000"
	expect(Color::Red.red?) == true
	expect(Color::Red.green?) == false
	expect(Color).to_be(:frozen?)
	expect(Color::Red).to_be(:frozen?)
	expect(Color[1]) == Color::Red
	expect(Color.cast(1)) == Color::Red
	expect(Color.to_set) == Set[Color::Red, Color::Green, Color::Blue]
	expect(Color.to_h) == { 1 => Color::Red, 2 => Color::Green, 3 => Color::Blue }
	expect(Color.to_a) == [Color::Red, Color::Green, Color::Blue] if RUBY_VERSION >= "3.2"
	expect(Color.values) == [1, 2, 3] if RUBY_VERSION >= "3.2"
	expect([3, 2, 1].map(&Color)) == [Color::Blue, Color::Green, Color::Red]

	expect(Switch::Off.toggle) == Switch::On
	expect(Switch::On.toggle) == Switch::Off
end

test "pattern matching" do
	Color::Red => Color
	Color::Red => Color[1]
	Color::Red => Color[hex: "#FF0000"]

	Color::Red => Color
	Color::Red => Color[1]
	Color::Red => Color::Red[hex: "#FF0000"]
end
