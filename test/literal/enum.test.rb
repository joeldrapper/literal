# frozen_string_literal: true

extend Literal::Types

Color = Literal::Enum(Integer).define do
	Red(0)
	Green(1)
	Blue(3)
	LightRed(4)
end

Switch = Literal::Enum(_Boolean).define do
	On(true)
	Off(false)
end

test do
	color = Color::Red
	assert color.is_a?(Color)
	assert color.red?
	refute color.light_red?
	expect(color.value) == 0
	expect(color.to_i) == 0

	expect(Color.cast(4)) == Color::LightRed

	on = Switch::On
	assert on.on?
	refute on.off?
	refute on.respond_to?(:to_i)

  expect(Color.reject { |c| c.red? }) == [Color::Green, Color::Blue, Color::LightRed]
end
