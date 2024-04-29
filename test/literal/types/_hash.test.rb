# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Hash(String, Integer) === { "a" => 1, "b" => 2, "c" => 3 }

	refute _Hash(String, Integer) === { "a" => 1, "b" => 2, 3 => "c" }
end

test "== method" do
	assert _Hash(String, Integer) == _Hash(String, Integer)
	assert _Hash(String, Integer).eql?(_Hash(String, Integer))

	assert _Hash(String, Integer) != _Hash(Integer, String)
	assert _Hash(String, Integer) != nil
	assert _Hash(String, Integer) != Object.new
end
