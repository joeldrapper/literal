# frozen_string_literal: true

include Literal::Types

test "inspect" do
	expect(_String(1..5).inspect) == "_String(1..5)"
end

# test "===" do
# 	assert _String(1..5) === "Hello"

# 	refute _String(1..5) === ""
# 	refute _String(1..5) === "Hello, world!"
# end

test "== method" do
	assert _String(1..5) == _String(1..5)
	assert _String(1..5).eql?(_String(1..5))
	assert _String(1..5) != _String(1..10)
	assert _String(1..5) != nil
	assert _String(1..5) != Object.new
end
