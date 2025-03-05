# frozen_string_literal: true

include Literal::Types

test "_Unit matches when value is the same object" do
	assert _Unit(1) === 1
	assert _Unit("a") === "a"
end

test "_Unit? matches when the value is the same object or nil" do
	assert _Unit?(1) === 1
	assert _Unit?(1) === nil

	refute _Unit(+"a") === +"a"
end
