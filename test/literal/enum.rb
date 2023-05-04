# frozen_string_literal: true

Color = Literal::Enum.define do
	Red("#ff0000")
	Green("#00ff00")
	Blue("#0000ff")
end

test do
	expect(Color::Red.value) == "#ff0000"
	expect(Color::Red.name) == "::Red"
	expect(Color.cast("#ff0000")) == Color::Red

	assert Color === Color::Red
	assert Color::Red.is_a?(Color)

	assert Color::Red.red?
end
