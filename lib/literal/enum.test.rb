# frozen_string_literal: true

extend Literal::Types

class Color < Literal::Enum(Integer)
	Red(1)
	Green(2)
	Blue(3)
end

class Switch < Literal::Enum(_Boolean)
	On(true) do
		def toggle = Off
	end

	Off(false) do
		def toggle = On
	end
end

test do
	expect(Color::Red.value) == 1
	expect(Color::Red.red?) == true
	expect(Color::Red.green?) == false
	expect(Color).to_be(:frozen?)
	expect(Color::Red).to_be(:frozen?)
	expect(Color[1]) == Color::Red
	expect(Color.cast(1)) == Color::Red
	expect(Color.to_set) == Set[Color::Red, Color::Green, Color::Blue]
	expect(Color.values) == [1, 2, 3]
	expect([3, 2, 1].map(&Color)) == [Color::Blue, Color::Green, Color::Red]

	expect(Switch::Off.toggle) == Switch::On
	expect(Switch::On.toggle) == Switch::Off
end
